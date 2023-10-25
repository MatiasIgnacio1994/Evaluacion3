import 'package:flutter/material.dart';
import 'package:carritocompras/providers/product_form_provider.dart';
import 'package:carritocompras/services/product_service.dart';
import 'package:carritocompras/widgets/product_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../ui/input_decorations.dart';

class EditProductScreen extends StatelessWidget {
  const EditProductScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductsService>(context);
    return ChangeNotifierProvider(
        create: (_) => ProductFormProvider(productService.selectedProduct),
        child: _ProductScreenBody(
          productService: productService,
        ));
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({Key? key, required this.productService})
      : super(key: key);

  final ProductsService productService;
  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    bool isLoading = false;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          Stack(
            children: [
              GestureDetector(
                onTap: () async {
                  print('Subir imagen');
                  final picker = ImagePicker();
                  final pickedFile = await picker.pickImage(
                      // source: ImageSource.gallery,
                      source: ImageSource.camera,
                      imageQuality: 100);

                  if (pickedFile == null) {
                    return;
                  }

                  productService.updateSelectedProductImage(pickedFile.path);
                },
                child: ProductImage(
                  url: productService.selectedProduct.productImage,
                ),
              ),
              Positioned(
                top: 40,
                left: 20,
                child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 40,
                      color: Colors.white,
                    )),
              ),
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                    onPressed: () => {},
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      size: 40,
                      color: Colors.white,
                    )),
              )
            ],
          ),
          _ProductForm(),
        ]),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              if (!productForm.isValidForm()) return;
              await productService.deleteProduct(productForm.product);
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
            },
            heroTag: null,
            child: const Icon(Icons.delete_forever),
          ),
          const SizedBox(width: 20),
          FloatingActionButton(
            onPressed: isLoading
                ? null
                : () async {
                    if (!productForm.isValidForm()) return;
                    isLoading = true;

                    final String? imageUrl = await productService.uploadImage();

                    if (imageUrl != null)
                      productForm.product.productImage = imageUrl;

                    await productService
                        .editOrCreateProduct(productForm.product);
                    isLoading = false;
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  },
            heroTag: null,
            child: const Icon(Icons.save_alt_outlined),
          ),
        ],
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: double.infinity,
        decoration: _createDecoration(),
        child: Form(
          key: productForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                initialValue: product.productName,
                onChanged: (value) => product.productName = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'el nombre es obligatorio';
                    return null;
                  }
                  return null;
                },
                decoration: InputDecortions.authInputDecoration(
                  hinText: 'Nombre del producto',
                  labelText: 'Nombre',
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.number,
                initialValue: product.productPrice.toString(),
                onChanged: (value) {
                  if (int.tryParse(value) == null) {
                    product.productPrice = "0";
                  } else {
                    product.productPrice = value;
                  }
                },
                decoration: InputDecortions.authInputDecoration(
                  hinText: '-----',
                  labelText: 'Precio',
                ),
              ),
              const SizedBox(height: 20),
              SwitchListTile.adaptive(
                value: true,
                onChanged: (value) {},
                activeColor: Colors.orange,
                title: const Text('Disponible'),
              )
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _createDecoration() => const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(0, 5),
              blurRadius: 10,
            )
          ]);
}
