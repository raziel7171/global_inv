//import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:global_inv/src/pages/add_product_form.dart';
import 'package:global_inv/src/pages/home_page.dart';
import 'package:global_inv/src/pages/product_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test/test.dart';

void main() {
  test("producto", () {
    AddProductForm crea = new AddProductForm();
    Map<String, dynamic> productData = {
      "code": "BCW65",
      "name": "cocu",
      "price": 4000,
      "quantity": 20
    };
    bool si = crea.createState().addData(appData: productData);
    print(si);
    print("holii");
    expect(si, true);
  });
}
