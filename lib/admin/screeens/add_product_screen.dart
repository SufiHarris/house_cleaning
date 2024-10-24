import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/general_functions/user_profile_image.dart';
import 'package:house_cleaning/user/models/product_model.dart';
import 'package:image_picker/image_picker.dart';
import '../provider/admin_provider.dart'; // Import your AdminProvider

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String? productName;
  double? productPrice;
  String? productDescription;

  final imageController = Get.put(ImageController()); // Get the ImageController
  final adminProvider =
      Get.find<AdminProvider>(); // Assuming you use AdminProvider for Firestore

  @override
  void initState() {
    super.initState();
    // Reset the image in ImageController when navigating to the screen
    imageController.image =
        null; // or you can directly call imageController.update()
  }

  // Save product data
  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Save the form state

      if (imageController.image != null) {
        // Upload image to Firebase and get the URL
        String imageUrl =
            await imageController.uploadImageToFirebase(imageController.image!);

        if (imageUrl.isNotEmpty) {
          // Prepare the product data using the model
          UserProductModel newProduct = UserProductModel(
            name: productName!,
            imageUrl: imageUrl, // Use the uploaded image URL
            price: productPrice!,
            description: productDescription,
            quantity: 1, // You can modify this to accept dynamic quantity
            brand: "YourBrand", // This can be dynamic as well
            deliveryTime:
                "2-3 days", // You can add a dynamic field for delivery time
          );

          // Call the provider's method to add the product to Firestore
          await adminProvider.addProduct(newProduct);

          Get.snackbar("Success", "Product added successfully!");
          Get.back(); // Go back after saving
        } else {
          Get.snackbar("Error", "Image upload failed.");
        }
      } else {
        Get.snackbar("Error", "Please upload a product image.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Image Upload Section using GetBuilder
              GestureDetector(
                onTap: _pickImage, // Trigger image picker
                child: GetBuilder<ImageController>(
                  init: imageController, // Initialize the ImageController
                  builder: (controller) {
                    return CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey.shade200,
                      child: controller.image == null
                          ? Icon(Icons.add_a_photo,
                              size: 40, color: Colors.brown)
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

              // Product Name Field
              TextFormField(
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

              // Product Price Field
              TextFormField(
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

              // Product Description Field
              TextFormField(
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

              // Cancel and Save Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Get.back(); // Cancel and go back
                    },
                    child: Text('Cancel'),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.brown),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _saveProduct, // Call the save function
                    child: Text('Save changes'),
                    style: ElevatedButton.styleFrom(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to pick image (trigger ImageController)
  void _pickImage() {
    Get.defaultDialog(
      title: "Choose Image",
      content: Column(
        children: [
          ElevatedButton.icon(
            onPressed: () {
              imageController.pickImageFromCamera();
              Get.back(); // Close the dialog
            },
            icon: Icon(Icons.camera),
            label: Text("Camera"),
          ),
          ElevatedButton.icon(
            onPressed: () {
              imageController.pickImageFromGallery();
              Get.back(); // Close the dialog
            },
            icon: Icon(Icons.photo),
            label: Text("Gallery"),
          ),
        ],
      ),
    );
  }
}
