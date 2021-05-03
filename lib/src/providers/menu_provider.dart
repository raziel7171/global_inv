import 'dart:convert';
// import 'dart:html';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:global_inv/src/objects/product.dart';

class _MenuProvider {
  List<dynamic> opciones = [];
  List<Product> productList = [];

  _MenuProvider() {}
  Map data;

  Future<List<dynamic>> cargarData() async {
    final resp =
        await rootBundle.loadString('lib/src/assets/data/products.json');
    Map dataMap = json.decode(resp);
    opciones = dataMap['products'];

    return opciones;
  }

  // Future<List<dynamic>> fetchData() async {
  //   CollectionReference collectionReference =
  //       FirebaseFirestore.instance.collection('products');
  //   collectionReference.snapshots().listen((snapshot) {
  //     data = snapshot.docs[0].data();
  //     productList = data['products'];
  //   });
  //   return productList;
  // }

  Future<List<Product>> fetchData() async {
    Stream<QuerySnapshot> collectionReference =
        FirebaseFirestore.instance.collection('products').snapshots();

    DatabaseReference databaseReference =
        FirebaseDatabase.instance.reference().child("products");
    databaseReference.once().then((DataSnapshot dataSnapshot) {
      productList.clear();
      var keys = dataSnapshot.value.keys;
      var values = dataSnapshot.value;

      for (var key in keys) {
        Product product = new Product(
            values[key],
            values[key]["name"],
            values[key]["price"],
            values[key]["quantity"],
            values[key]["icon"],
            values[key]["description"],
            values[key]["route"]);
        productList.add(product);
      }
    });
    return productList;
  }
}

Widget loadImage(
    BuildContext context, String imgName, double imgHeight, double imgWidth) {
  return Image(
      image: AssetImage('lib/src/assets/images/' + imgName + '.png'),
      height: imgHeight,
      width: imgWidth);
}

final menuProvider = new _MenuProvider();
