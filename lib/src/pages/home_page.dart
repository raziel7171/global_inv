import 'package:flutter/material.dart';
import 'package:global_inv/src/objects/productModel.dart';
import 'package:global_inv/src/pages/add_product_form.dart';
import 'package:global_inv/src/pages/product_page.dart';
import 'package:global_inv/src/providers/products_provider.dart';
import 'package:global_inv/src/utils/icon_string_util.dart';

import 'add_product_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ProductsProvider productsProvider = new ProductsProvider();
  List<ProductModel> productList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Global - Inv'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.menu),
        onPressed: () {
          Navigator.pushNamed(context, AddProductForm.routeName);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      body: _lista(),
    );
  }

  Widget _lista() {
    return FutureBuilder(
      future: productsProvider.readProducts(),
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
        if (snapshot.hasData) {
          final productsList = snapshot.data;
          return ListView.builder(
              itemCount: productsList.length,
              itemBuilder: (context, i) => _showProductWidget(productsList[i]));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _showProductWidget(ProductModel product) {
    return ListTile(
      title: Text(product.name),
      subtitle: Text(product.price.toString() + "＄"),
      leading: Text(product.quantity.toString() + 'x'),
      trailing: IconButton(
          icon: getIcon(product.icon), onPressed: () => product.quantity - 1),
      onTap: () {
        Navigator.pushNamed(context, ProductPage.routeName,
            arguments: ProductArguments(product.name, product));
      },
    );
  }

  List<Widget> _listaItems(List<dynamic> data, BuildContext context) {
    final List<Widget> opciones = [];

    // for (Product product in data) {
    //   final int quantity = product.quantity;
    //   final widgetTemp = ListTile(
    //     title: Text(product.name),
    //     subtitle: Text(product.price.toString() + "＄"),
    //     leading: Text(quantity.toString() + 'x'),
    //     trailing: IconButton(
    //         icon: getIcon(product.icon), onPressed: () => quantity - 1),
    //     onTap: () {
    //       Navigator.pushNamed(context, ProductPage.routeName,
    //           arguments: ProductArguments(product.name, product));
    //     },
    //   );
    //   opciones..add(widgetTemp)..add(Divider());
    // }

    data.forEach((opt) {
      final int quantity = opt['quantity'];
      final widgetTemp = ListTile(
        title: Text(opt['name']),
        subtitle: Text(opt['price'].toString() + "＄"),
        leading: Text(quantity.toString() + 'x'),
        trailing: IconButton(
            icon: getIcon(opt['icon']), onPressed: () => quantity - 1),
        onTap: () {
          Navigator.pushNamed(context, ProductPage.routeName,
              arguments: ProductArguments(opt['name'], opt));
        },
      );
      opciones..add(widgetTemp)..add(Divider());
    });
    return opciones;
  }

  void subtract(dynamic product) => product['quantity'] - 1;
}

class ProductArguments {
  final String name;
  final dynamic specificProduct;
  ProductArguments(this.name, this.specificProduct);
}
