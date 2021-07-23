// To parse this JSON data, do
//
//     final saleModel = saleModelFromJson(jsonString);

import 'dart:convert';

import 'productSaleModel.dart';

Map<String, SaleModel> saleModelFromJson(String str) =>
    Map.from(json.decode(str))
        .map((k, v) => MapEntry<String, SaleModel>(k, SaleModel.fromJson(v)));

String saleModelToJson(SaleModel data) => json.encode(data.toJson());
DateTime today = new DateTime.now();

class SaleModel {
  SaleModel({
    this.date,
    this.id,
    this.products,
    this.total = 0,
  });

  DateTime date;
  String id;
  Map<String, ProductSaleModel> products;
  double total;

  factory SaleModel.fromJson(Map<String, dynamic> json) => SaleModel(
        date: DateTime.parse(json["date"]),
        id: json["id"],
        products: Map.from(json["products"]).map((k, v) =>
            MapEntry<String, ProductSaleModel>(
                k, ProductSaleModel.fromJson(v))),
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "date": date.toIso8601String(),
        "id": id,
        "products": Map.from(products)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "total": total,
      };
}
