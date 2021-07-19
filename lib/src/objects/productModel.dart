// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel({
    this.id,
    this.name,
    this.price = 0.0,
    this.quantity = 0,
    this.icon,
    this.description,
    this.route,
  });

  String id;
  String name;
  double price;
  int quantity;
  String icon;
  String description;
  String route;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        name: json["name"],
        price: json["price"].toDouble(),
        quantity: json["quantity"].toInt(),
        icon: json["icon"],
        description: json["description"],
        route: json["route"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "quantity": quantity,
        "icon": icon,
        "description": description,
        "route": route,
      };
}
