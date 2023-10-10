import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:deepar_shoe_try_on_flutter/deepar_shoe_try_on_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'DeepAR Shoe Try-On Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const TryOnList(tryOns: [
        TryOn(link: "https://demo.deepar.ai/flutter/shoe/nike-airforce1.deepar", name: "Nike Air Force 1", image: AssetImage("assets/shoe_images/67ebf869-c136-4ac4-87f9-d65caeeda6a0.png")),
        TryOn(link: "https://demo.deepar.ai/flutter/shoe/nike-airforce-1-lv8.deepar", name: "Nike Air Force 1 LV8", image: AssetImage("assets/shoe_images/71afbadb-9239-45a1-8b8c-30cb44a8fef8.png")),
        TryOn(link: "https://demo.deepar.ai/flutter/shoe/nike-dunk.deepar", name: "Nike Dunk", image: AssetImage("assets/shoe_images/1265ac25-947e-4379-8961-7d3153960163.png")),
        TryOn(link: "https://demo.deepar.ai/flutter/shoe/on-run-cloudmonster.deepar", name: "On Running Cloudmonster", image: AssetImage("assets/shoe_images/642fb761-6351-4d5e-a8ea-deea10c1aec5.png")),
        TryOn(link: "https://demo.deepar.ai/flutter/shoe/on-run-cloudrock.deepar", name: "On Running Cloudrock", image: AssetImage("assets/shoe_images/3c4d3ff2-0cd8-43cf-9d4d-3bfc6822ddd8.png")),
        TryOn(link: "https://demo.deepar.ai/flutter/shoe/puma-suede-classic.deepar", name: "Puma Suede Classic", image: AssetImage("assets/shoe_images/18c9bd15-4fb2-43ee-a078-8994ae2b9bd1.png")),
        TryOn(link: "https://demo.deepar.ai/flutter/shoe/puma-voltaire.deepar", name: "Puma Voltaire", image: AssetImage("assets/shoe_images/0183c63b-b18b-445f-9158-deee55727e6a.png")),
        TryOn(link: "https://demo.deepar.ai/flutter/shoe/new-balance-574.deepar", name: "New Balance 574", image: AssetImage("assets/shoe_images/1515d524-c04d-45a7-abe8-1ef79c4afaa3.png")),
      ])
    );
  }
}

class TryOn {
  const TryOn({required this.link, required this.name, required this.image});

  final String link;
  final String name;
  final AssetImage image;
}

class TryOnListItem extends StatelessWidget {
  TryOnListItem({
    required this.tryOn,
    required this.onTryOnClicked
  }) : super(key: ObjectKey(tryOn));

  final TryOn tryOn;
  final VoidCallback onTryOnClicked;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTryOnClicked,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image(image: tryOn.image),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 4,
                    child: Text(
                      tryOn.name,
                      style: const TextStyle(
                        color: Colors.white,
                        backgroundColor: Colors.black,
                        fontSize: 20.0,
                        decoration: TextDecoration.none,
                        overflow: TextOverflow.visible
                      ),
                    )
                ),
                Expanded(
                    flex: 2,
                    child: ElevatedButton(onPressed: onTryOnClicked, child: const Text("AR Try-On",))
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class TryOnList extends StatelessWidget {
  const TryOnList({required this.tryOns, super.key});
  final List<TryOn> tryOns;
  
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      children: tryOns.map((tryOn) {
        return TryOnListItem(
            tryOn: tryOn,
            onTryOnClicked: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => TryOnPreview(tryOn: tryOn)));
            }
        );
      }).toList(),
    );
  }
}

class TryOnPreview extends StatelessWidget {
  const TryOnPreview({required this.tryOn, super.key});

  final TryOn tryOn;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(),
        child: DeepARShoeTryOnPreview(link: Uri.parse(tryOn.link))
    );
  }
}