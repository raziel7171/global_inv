// To parse this JSON data, do
//
//     final saleModel = saleModelFromJson(jsonString);

import 'dart:convert';

import 'productSaleModel.dart';

Map<String, SaleModel> saleModelFromJson(String str) =>
    Map.from(json.decode(str))
        .map((k, v) => MapEntry<String, SaleModel>(k, SaleModel.fromJson(v)));

String saleModelToJson(SaleModel data) => json.encode(data.toJson());

class SaleModel {
  DateTime date;
  String id;
  double total;
  List<ProductSaleModel> products;

  SaleModel({this.date, this.id, this.total = 0, products});

  factory SaleModel.fromJson(Map<String, dynamic> json) => SaleModel(
        date: json["date"] == null ? null : json["date"],
        id: json["id"] == null ? null : json["id"],
        total: json["total"] == null ? null : json["total"],
        products: json["items"] == null
            ? null
            : List<ProductSaleModel>.from(
                json["items"].map((x) => ProductSaleModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "date": date.toIso8601String(),
        "id": id,
        "total": total,
        "products": products == null
            ? null
            : List<dynamic>.from(products.map((x) => x.toJson())),
      };
}
