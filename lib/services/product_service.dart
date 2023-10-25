import 'dart:convert';
import 'dart:io';

import 'package:carritocompras/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Cart {
  late String checkout;
  late Product product;
  late int amount;

  Cart({required this.product, required this.amount});
}

class ProductsService extends ChangeNotifier {
  final String _baseUrl = 'market-app-15eb5-default-rtdb.firebaseio.com';
  List<Product> products = [];
  List<Cart?> cart = [];
  List<Cart?> checkout = [];
  bool updateCart = false;
  late Product selectedProduct;
  bool isEditCreate = true;
  int amount = 0;
  double total = 0.0;

  final storage = const FlutterSecureStorage();

  File? newPictureFile;

  bool isLoading = true;
  bool isSaving = false;

  ProductsService() {
    loadProducts();
  }

  void addToCart(Product product) {
    var cartItem = cart.firstWhere((item) => item?.product == product,
        orElse: () => Cart(product: product, amount: -1));

    if (cartItem!.amount == -1) {
      cartItem = null;
    }
    if (cartItem != null) {
      cartItem.amount++;
    } else {
      cart.add(Cart(product: product, amount: 1));
    }

    total = calculateTotal();
    amount = calculateAmount();
    notifyListeners();
  }

  void removeFromCart(Cart? cartItem) {
    if (cartItem!.amount > 1) {
      cartItem.amount--;
    } else {
      cart.remove(cartItem);
    }

    total = calculateTotal();
    amount = calculateAmount();
    notifyListeners();
  }

  double calculateTotal() {
    return cart.fold(0.0, (double total, Cart? cartItem) {
      return total +
          (int.parse(cartItem!.product.productPrice) * cartItem.amount);
    });
  }

  int calculateAmount() {
    return cart.fold(0, (int total, Cart? cartItem) {
      return total + cartItem!.amount;
    });
  }

  Future reloadData() async {
    notifyListeners();
  }

  Future<List<Product>> loadProducts() async {
    this.products = [];
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'products.json',
        {'auth': await storage.read(key: 'token') ?? ''});
    final res = await http.get(url);

    final productsMap = json.decode(res.body);

    if (productsMap == "") {
      return this.products;
    }

    if (productsMap == null || productsMap == "") {
      this.isLoading = false;
      notifyListeners();
      return this.products;
    }

    productsMap.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.productId = key;
      products.add(tempProduct);
    });

    isLoading = false;
    notifyListeners();

    return products;
  }

  Future CreateCart() async {
    final url = Uri.https(_baseUrl, 'cart.json',
        {'auth': await storage.read(key: 'token') ?? ''});

    final transacction = DateTime.now().millisecondsSinceEpoch;

    for (final cartItem in cart) {
      var converted = {
        "transaction": transacction.toString(),
        "productId": cartItem!.product.productId,
        "productName": cartItem.product.productName,
        "amount": cartItem.amount
      };

      final resp = await http.post(url, body: json.encode(converted));
      final decodedData = json.decode(resp.body);

      cartItem.checkout = decodedData['name'];

      checkout.add(cartItem);
    }

    cart.clear();
    notifyListeners();

    return cart;
  }

  Future saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();

    if (product.productId == "0") {
      // Es necesario crear
      await createProduct(product);
    } else {
      // Actualizar
      await updateProduct(product, json.encode(product));
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Product product, String productJson) async {
    final url = Uri.https(_baseUrl, 'products/${product.productId}.json',
        {'auth': await storage.read(key: 'token') ?? ''});

    final resp = await http.put(url, body: productJson);
    final decodedData = resp.body;

    final index = products
        .indexWhere((element) => element.productId == product.productId);
    products[index] = product;

    return product.productId;
  }

  Future<String> createProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products.json',
        {'auth': await storage.read(key: 'token') ?? ''});

    final resp = await http.post(url, body: json.encode(product));
    final decodedData = json.decode(resp.body);

    product.productId = decodedData['name'];

    products.add(product);

    return product.productId;
  }

  void updateSelectedProductImage(String path) {
    selectedProduct.productImage = path;
    newPictureFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (newPictureFile == null) return null;

    isSaving = true;
    notifyListeners();

    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/de5vgqvvd/image/upload?upload_preset=w6oyp2od');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file =
        await http.MultipartFile.fromPath('file', newPictureFile!.path);

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print(resp.body);
      return null;
    }

    newPictureFile = null;

    final decodedData = json.decode(resp.body);
    return decodedData['secure_url'];
  }

  Future editOrCreateProduct(Product product) async {
    isEditCreate = true;
    notifyListeners();
    if (product.productId == "0") {
      await createProduct(product);
    } else {
      await updateProduct(product, json.encode(product));
    }

    isEditCreate = false;
    notifyListeners();
  }

  Future<String> deleteProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products/${product.productId}.json',
        {'auth': await storage.read(key: 'token') ?? ''});

    final resp = await http.delete(url, body: product.toJson());
    final decodedData = resp.body;

    loadProducts();
    notifyListeners();
    return '';
  }
}
