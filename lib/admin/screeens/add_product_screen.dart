import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String? productName;
  double? productPrice;
  String? productDescription;
  XFile? productImage;

  final ImagePicker _picker = ImagePicker();

  // Function to pick image from gallery
  Future<void> _pickImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      productImage = pickedImage;
    });
  }

  // Function to save the product (placeholder function)

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
              // Image Upload Section
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade200,
                  child: productImage == null
                      ? Icon(Icons.add_a_photo, size: 40, color: Colors.brown)
                      : ClipOval(
                          child: Image.file(
                            File(productImage!.path),
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          ),
                        ),
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
                    onPressed: () {},
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
}
