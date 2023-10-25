import 'package:flutter/material.dart';
import 'package:carritocompras/models/product.dart';
import 'package:carritocompras/services/product_service.dart';
import 'package:carritocompras/widgets/product_card.dart';
import 'package:provider/provider.dart';
import 'package:carritocompras/screen/screen.dart';

class ListProductScreen extends StatefulWidget {
  const ListProductScreen({Key? key}) : super(key: key);

  @override
  State<ListProductScreen> createState() => _ListProductScreen();
}

class _ListProductScreen extends State<ListProductScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _data = [];
  List<Product> _filteredData = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
  final productService = Provider.of<ProductsService>(context);
  String dropdownValue = 'Categoria';

  Future<void> _performSearch(text) async {
    print('llama');
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 1000));

    setState(() {
      _filteredData = productService.products
          .where((product) =>
              product.productName.toLowerCase().contains(text))
          .toList();
      _isLoading = false;
    });
  }


    if (productService.isLoading) return const LoadingScreen();
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.purple.shade300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: TextField(
          controller: _searchController,
          onChanged: (text){
            _performSearch(text);
          },
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: const InputDecoration(
            hintText: 'Busqueda...',
            hintStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none,
          ),
        ),
        actions: [
          DropdownButton(
            icon: const Icon(Icons.filter_alt_rounded, color: Colors.white),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
            items: <String>['Categoria']
                .map<DropdownMenuItem<String>>(
              (String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              },
            ).toList(),
          ),
          IconButton(
            icon: Container(child: Stack(children: [const Icon(Icons.shopping_cart),Text(productService.amount.toString(), style: const TextStyle(color: Colors.purple),)]),),
            tooltip: 'Carrito',
            onPressed: () {
              print('prueba');
              Navigator.pushNamed(context, 'cart');
            },
          ),
        ],
      ),
      body: _isLoading
            ? 
            const Center(
                child: CircularProgressIndicator(color: Colors.purple),
              ) : ListView.builder(
        itemCount: _filteredData.isNotEmpty ? _filteredData.length : productService.products.length,
        itemBuilder: (BuildContext context, index) => GestureDetector(
          child: ProductCard(product: _filteredData.isNotEmpty ? _filteredData[index] : productService.products[index], index: index,),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          productService.selectedProduct = Product(
              productId: "0",
              productName: '',
              productPrice: "0",
              productImage:
                  'https://abravidro.org.br/wp-content/uploads/2015/04/sem-imagem4.jpg',
              productState: '');
          Navigator.pushNamed(context, 'edit');
        },
      ),
    );
  }
}
