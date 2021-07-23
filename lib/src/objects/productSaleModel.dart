class ProductSaleModel {
  ProductSaleModel({
    this.idProduct,
    this.name,
    this.price,
    this.quantity,
    this.max,
  });

  String idProduct;
  String name;
  double price;
  int quantity;
  int max;

  factory ProductSaleModel.fromJson(Map<String, dynamic> json) =>
      ProductSaleModel(
        idProduct: json["idProduct"],
        name: json["name"],
        price: json["price"],
        quantity: json["quantity"],
        max: json["max"],
      );

  Map<String, dynamic> toJson() => {
        "idProduct": idProduct,
        "name": name,
        "price": price,
        "quantity": quantity,
        "max": max,
      };
}
