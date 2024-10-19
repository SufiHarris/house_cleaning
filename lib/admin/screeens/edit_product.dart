import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/general_functions/user_profile_image.dart';
import 'package:house_cleaning/user/models/product_model.dart';
import '../provider/admin_provider.dart';

class EditProductScreen extends StatefulWidget {
  final UserProductModel product;

  EditProductScreen({required this.product});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String? productName;
  double? productPrice;
  String? productDescription;
  final imageController = Get.put(ImageController());
  final adminProvider = Get.find<AdminProvider>();

  @override
  void initState() {
    super.initState();
    productName = widget.product.name;
    productPrice = widget.product.price;
    productDescription = widget.product.description;
    imageController.image = null; // Reset the image
  }

  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String imageUrl = widget.product.imageUrl;

      if (imageController.image != null) {
        imageUrl =
            await imageController.uploadImageToFirebase(imageController.image!);
      }

      UserProductModel updatedProduct = UserProductModel(
        name: productName!,
        imageUrl: imageUrl,
        price: productPrice!,
        description: productDescription,
        quantity: widget.product.quantity,
        brand: widget.product.brand,
        deliveryTime: widget.product.deliveryTime,
        productId: widget.product.productId, // Keep existing product ID
      );

      await adminProvider.updateProduct(updatedProduct);

      Get.snackbar("Success", "Product updated successfully!");
      Get.back(); // Go back after saving
    }
  }

  void _deleteProduct() async {
    await adminProvider.deleteProduct(widget.product.productId!);
    Get.snackbar("Success", "Product deleted successfully!");
    Get.back();
  }

  void _pickImage() {
    Get.defaultDialog(
      title: "Choose Image",
      content: Column(
        children: [
          ElevatedButton.icon(
            onPressed: () {
              imageController.pickImageFromCamera();
              Get.back();
            },
            icon: Icon(Icons.camera),
            label: Text("Camera"),
          ),
          ElevatedButton.icon(
            onPressed: () {
              imageController.pickImageFromGallery();
              Get.back();
            },
            icon: Icon(Icons.photo),
            label: Text("Gallery"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: GetBuilder<ImageController>(
                  init: imageController,
                  builder: (controller) {
                    return CircleAvatar(
                      radius: 50, // Ensure correct radius for circle
                      backgroundColor: Colors.grey.shade200,
                      child: controller.image == null
                          ? ClipOval(
                              child: Image.network(
                                widget.product.imageUrl,
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.error),
                              ),
                            )
                          : ClipOval(
                              child: Image.file(
                                File(controller.image!.path),
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                              ),
                            ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: productName,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  hintText: 'Ex. Steel Mop',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the product name';
                  }
                  return null;
                },
                onSaved: (value) {
                  productName = value;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: productPrice?.toString(),
                decoration: InputDecoration(
                  labelText: 'Price',
                  hintText: 'Ex. \$30',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the product price';
                  }
                  final parsedValue = double.tryParse(value);
                  if (parsedValue == null) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
                onSaved: (value) {
                  productPrice = double.tryParse(value!);
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: productDescription,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Write product description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product description';
                  }
                  return null;
                },
                onSaved: (value) {
                  productDescription = value;
                },
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _deleteProduct,
                    child: Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _saveProduct,
                    child: Text('Save Changes'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
