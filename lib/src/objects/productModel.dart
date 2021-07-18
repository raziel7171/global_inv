// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel({
    this.code,
    this.name,
    this.price,
    this.quantity = 0,
    this.icon,
    this.description,
    this.route,
  });

  String code;
  String name;
  double price;
  int quantity;
  String icon;
  String description;
  String route;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        code: json["code"],
        name: json["name"],
        price: json["price"].toDouble(),
        quantity: json["quantity"],
        icon: json["icon"],
        description: json["description"],
        route: json["route"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "price": price,
        "quantity": quantity,
        "icon": icon,
        "description": description,
        "route": route,
      };
}
