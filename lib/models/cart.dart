// import 'dart:convert';

// import 'package:carritocompras/models/product.dart';

// class Cart {
//   late String checkout;
//   late Product product;
//   late int amount;

//   Cart({required this.product, required this.amount});


//   factory Cart.fromJson(String str) => Cart.fromMap(json.decode(str));


//   factory Cart.fromMap(Map<String, dynamic> json) => Cart(
//     productId: json['productId'],
//     productName: json['productName'],
//     productPrice: json['productPrice'].toString(),
//     productImage: json['productImage'],
//     productState: json['productState']
// );

//   factory Cart.fromJsonMap(Map<String, dynamic> json) {
//     return Cart(
//       productId: json['productId'] as String,
//       productName: json['productName'] as String,
//       productPrice: json['productPrice'] as String,
//       productImage: json['productImage'] as String,
//       productState: json['productState'] as String,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'productId': productId,
//       'productName': productName,
//       'productPrice': productPrice,
//       'productImage': productImage,
//       'productState': productState,
//     };
//   }

//     Product copy() => Product(
//       productId: productId,
//       productName: productName,
//       productPrice: productPrice,
//       productImage: productImage,
//       productState: productState);
// }