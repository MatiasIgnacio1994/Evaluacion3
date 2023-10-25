import 'package:flutter/material.dart';
import 'package:carritocompras/services/product_service.dart';
import 'package:carritocompras/widgets/cart_item.dart';
import 'package:provider/provider.dart';
import 'package:carritocompras/screen/screen.dart';

class CartProductScreen extends StatefulWidget {
  const CartProductScreen({super.key});

  @override
  State<CartProductScreen> createState() => _CartProductScreenState();
}

class _CartProductScreenState extends State<CartProductScreen> {
  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductsService>(context);
    if (productService.isLoading) return const LoadingScreen();
    return Scaffold(
      appBar: AppBar(
        title: Text('Total de Compras: ${productService.total}'),
        actions: [
          IconButton(onPressed: () async {
            final cartFinal = await productService.CreateCart();
            
          }, icon: const Icon(Icons.shopping_cart_checkout))
        ],
      ),
      body: ListView.builder(
        itemCount: productService.cart.length,
        itemBuilder: (BuildContext context, index){
          Cart? item = productService.cart[index];
                return CardCart(cart: item);
        }
      ),
    );
  }
}
