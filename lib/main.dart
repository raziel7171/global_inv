import 'package:flutter/material.dart';
import 'package:global_inv/src/pages/add_product_form.dart';
import 'package:global_inv/src/pages/home_page.dart';
import 'package:global_inv/src/pages/product_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

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
          AddProductForm.routeName: (context) => AddProductForm(),
        });
  }
}
