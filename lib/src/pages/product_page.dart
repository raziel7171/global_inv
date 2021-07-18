import 'package:flutter/material.dart';
import 'package:global_inv/src/pages/home_page.dart';
import 'package:global_inv/src/providers/menu_provider.dart';

class ProductPage extends StatefulWidget {
  static const routeName = '/product';
  ProductPage({Key key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    final ProductArguments args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Product: ' + args.name),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: [
            Row(
              children: [
                loadImage(context, args.name, 100, 100),
                VerticalDivider(),
                Expanded(
                  flex: 5,
                  child: Container(
                    child: Text.rich(TextSpan(
                        text: args.specificProduct.name + "\n\n",
                        style: TextStyle(fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Precio: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              children: <TextSpan>[
                                TextSpan(
                                    text:
                                        args.specificProduct.price.toString() +
                                            "＄",
                                    style: TextStyle(
                                        color: Colors.green.withOpacity(0.8)))
                              ])
                        ])),
                  ),
                ),
              ],
            ),
            Divider(),
            Container(
              alignment: Alignment.topLeft,
              child: Text.rich(TextSpan(
                  text: 'Descripción: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                    TextSpan(
                        text: args.specificProduct.description,
                        style: TextStyle(fontWeight: FontWeight.normal))
                  ])),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
