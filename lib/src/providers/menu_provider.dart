import 'dart:convert';
// import 'dart:html';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:global_inv/src/objects/productModel.dart';
import 'package:global_inv/src/providers/products_provider.dart';

class _MenuProvider {
  List<dynamic> opciones = [];
  List<ProductModel> productList = [];

  _MenuProvider() {}
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
