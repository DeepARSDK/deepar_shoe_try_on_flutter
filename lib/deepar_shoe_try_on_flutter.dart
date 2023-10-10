library deepar_shoe_try_on_flutter;

import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

/// A widget for displaying AR Shoe Try On.
class DeepARShoeTryOnPreview extends StatelessWidget {
  /// Constructs a [DeepARShoeTryOnPreview]
  /// 
  /// `link`: A [Uri] that references which shoe try on to preview.
  DeepARShoeTryOnPreview({super.key, required this.link}) {
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      params = AndroidWebViewControllerCreationParams();
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    controller = WebViewController.fromPlatformCreationParams(params, onPermissionRequest: (request) async {
      for(WebViewPermissionResourceType type in request.types) {
        var name = type.name;
        print("Requested permission: $name");
        if(name == "camera") {
          var status = await Permission.camera.request();
          if(status.isGranted) {
            await request.grant();
            print("Permission $name granted!");
          } else {
            await request.deny();
            print("Permission $name denied (status: $status)!");
          }
        } else {
          await request.deny();
          print("Permission $name denied (not recognized)!");
        }
      }
    },)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            print("Progress: $progress");
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {
            print("Web resource error: ${error.description}");
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://try.deepar.ai/flutter/shoe')) {
              return NavigationDecision.navigate;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..setOnConsoleMessage((message) {
        print(message.message);
      });

    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      final WebKitWebViewController webKitController = controller.platform as WebKitWebViewController;
      webKitController.setInspectable(true);
    } else if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      final AndroidWebViewController androidController = controller.platform as AndroidWebViewController;
      androidController.setMediaPlaybackRequiresUserGesture(false);
    }

    controller.loadRequest(Uri.parse('$kBaseUrl?e=$link'));
  }

  late final WebViewController controller;
  final Uri link;
  static const String kBaseUrl = "https://try.deepar.ai/flutter/shoe";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // On Android, sometimes the camera will not get closed after the web view gets disposed.
          // This is a workaround to close the camera by going to some web page that doesn't use the camera.
          controller.loadRequest(Uri.parse("http://www.noexisting"));
          return true;
        },
        child: WebViewWidget(controller: controller),
    );
  }
}
