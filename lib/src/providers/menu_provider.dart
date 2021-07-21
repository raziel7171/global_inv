import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:global_inv/src/objects/productModel.dart';

class _MenuProvider {
  List<dynamic> opciones = [];
  List<ProductModel> productList = [];

  _MenuProvider();
  Map data;

  Future<List<ProductModel>> cargarData() async {
    final resp =
        await rootBundle.loadString('lib/src/assets/data/products.json');
    Map dataMap = json.decode(resp);
    opciones = dataMap['products'];

    return opciones;
  }
}

Widget loadImage(
    BuildContext context, String imgName, double imgHeight, double imgWidth) {
  imgName = "Pen";
  return Image(
      image: AssetImage('lib/src/assets/images/' + imgName + '.png'),
      height: imgHeight,
      width: imgWidth);
}

final menuProvider = new _MenuProvider();
