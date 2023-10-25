import 'package:carritocompras/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class CardCart extends StatefulWidget {
  final Cart? cart;

  const CardCart({super.key, 
    required this.cart
  });

  @override
  State<CardCart> createState() => _CardCartState();
}

class _CardCartState extends State<CardCart> {
  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductsService>(context);

    return Card(
      elevation: 4, // Elevación de la tarjeta
      margin: const EdgeInsets.all(16), // Márgenes alrededor de la tarjeta
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.cart!.product.productName + widget.cart!.amount.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${int.parse(widget.cart!.product.productPrice).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
                Text(
                  widget.cart!.product.productState,
                  style: TextStyle(
                    fontSize: 16,
                    color: widget.cart?.product.productState == 'Available' ? Colors.green : Colors.red,
                  ),
                ),
                IconButton(onPressed: () {
                    productService.removeFromCart(widget.cart);
                    productService.reloadData();
            }, icon: const Icon(Icons.delete))
              ],
            ),
          ),
        ],
      ),
    );
  }
}