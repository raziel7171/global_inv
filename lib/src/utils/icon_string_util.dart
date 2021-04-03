import 'package:flutter/material.dart';

final _icons = <String, IconData>{
  'add_shopping_cart': Icons.add_shopping_cart,
  '': Icons.add_shopping_cart
};

Icon getIcon(String nameIcon) {
  return Icon(_icons[nameIcon], color: Colors.blue);
}
// Icon(_icons[nameIcon], color: Colors.blue)
