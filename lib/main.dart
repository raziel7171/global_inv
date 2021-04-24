import 'package:flutter/material.dart';
import 'package:global_inv/src/pages/home_page.dart';
import 'package:global_inv/src/pages/product_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Componentes App',
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) => HomePage(),
          // 'product': (BuildContext context) => ProductPage(),
          ProductPage.routeName: (context) => ProductPage(),
        });
  }
}
