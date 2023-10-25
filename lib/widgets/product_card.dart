import 'package:carritocompras/models/product.dart';
import 'package:carritocompras/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final int index;

  const ProductCard({super.key, required this.product, required this.index});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductsService>(context);

    return Card(
      elevation: 4, // Elevación de la tarjeta
      margin: const EdgeInsets.all(16), // Márgenes alrededor de la tarjeta
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: (){
            productService.selectedProduct =
                productService.products[widget.index].copy();
            Navigator.pushNamed(context, 'edit');
            },
            child: Image.network(
              widget.product.productImage, // URL de la imagen del producto
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.product.productName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${int.parse(widget.product.productPrice).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
                Text(
                  widget.product.productState,
                  style: TextStyle(
                    fontSize: 16,
                    color: widget.product.productState == 'Available'
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      productService.addToCart(widget.product);
                    },
                    icon: const Icon(Icons.add))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
