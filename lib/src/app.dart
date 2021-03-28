import 'package:flutter/material.dart';
import 'package:global_inv/src/pages/home_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Center(
        child: HomePage(),
      ),
    );

    throw UnimplementedError();
  }
}
