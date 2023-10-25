import 'dart:convert';

class Product {
  String productId;
  String productName;
  String productPrice;
  String productImage;
  String productState;

  Product({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.productState,
  });

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));


  factory Product.fromMap(Map<String, dynamic> json) => Product(
    productId: json['productId'],
    productName: json['productName'],
    productPrice: json['productPrice'].toString(),
    productImage: json['productImage'],
    productState: json['productState']
);

  factory Product.fromJsonMap(Map<String, dynamic> json) {
    return Product(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      productPrice: json['productPrice'] as String,
      productImage: json['productImage'] as String,
      productState: json['productState'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'productPrice': productPrice,
      'productImage': productImage,
      'productState': productState,
    };
  }

    Product copy() => Product(
      productId: productId,
      productName: productName,
      productPrice: productPrice,
      productImage: productImage,
      productState: productState);
}