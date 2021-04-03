import 'package:flutter/material.dart';
import 'package:global_inv/src/pages/alert_page.dart';
import 'package:global_inv/src/pages/product_page.dart';
import 'package:global_inv/src/providers/menu_provider.dart';
import 'package:global_inv/src/utils/icon_string_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Global - Inv'),
      ),
      body: _lista(),
    );
  }

  Widget _lista() {
    return FutureBuilder(
      future: menuProvider.cargarData(),
      initialData: [],
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        return ListView(
          children: _listaItems(snapshot.data, context),
        );
      },
    );
  }

  List<Widget> _listaItems(List<dynamic> data, BuildContext context) {
    final List<Widget> opciones = [];

    data.forEach((opt) {
      final int quantity = opt['quantity'];
      final widgetTemp = ListTile(
        title: Text(opt['productName']),
        subtitle: Text(opt['productPrice'].toString() + "＄"),
        leading: Text(quantity.toString() + 'x'),
        trailing: IconButton(
            icon: getIcon(opt['icon']), onPressed: () => quantity - 1),
        onTap: () {
          Navigator.pushNamed(context, ProductPage.routeName,
              arguments: ProductArguments(opt['productName'], opt));
        },
      );
      opciones..add(widgetTemp)..add(Divider());
    });
    return opciones;
  }

  void subtract(dynamic product) => product['quantity'] - 1;
}

class ProductArguments {
  final String productName;
  final dynamic specificProduct;
  ProductArguments(this.productName, this.specificProduct);
}
