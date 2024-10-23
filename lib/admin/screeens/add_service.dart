import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/admin/provider/admin_provider.dart';
import 'package:house_cleaning/general_functions/user_profile_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:house_cleaning/user/models/service_model.dart';
import 'package:house_cleaning/user/models/category_model.dart';

class AddServiceScreen extends StatefulWidget {
  @override
  _AddServiceScreenState createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  String? serviceName;
  String? serviceNameAr;
  CategoryModel? selectedCategory; // For dropdown selection
  int? price;
  int? baseSize;
  int? basePrice;

  final imageController = Get.put(ImageController()); // Image Controller
  final adminProvider = Get.find<AdminProvider>(); // AdminProvider instance

  @override
  void initState() {
    super.initState();
    imageController.image = null; // Reset the image when the screen loads
    adminProvider.fetchCategories(); // Fetch categories when screen loads
  }

  // Save service data
  void _saveService() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (imageController.image != null && selectedCategory != null) {
        String imageUrl =
            await imageController.uploadImageToFirebase(imageController.image!);

        if (imageUrl.isNotEmpty) {
          // Use both English and Arabic category names
          String categoryEnglish = selectedCategory!.categoryName;

          // Prepare the service data using the model
          ServiceModel newService = ServiceModel(
            serviceName: serviceName!,
            serviceNameAr: serviceNameAr!,
            serviceId: '', // Empty, will be updated later
            category: categoryEnglish, // Use English category name
            categoryAr: categoryEnglish, // Use Arabic category name
            image: imageUrl,
            price: price!,
            baseSize: baseSize!,
            basePrice: basePrice!,
          );

          // Call the provider's method to add the service to Firestore
          await adminProvider.addService(newService);

          Get.snackbar("Success", "Service added successfully!");
          Get.back(); // Go back after saving
        } else {
          Get.snackbar("Error", "Image upload failed.");
        }
      } else {
        Get.snackbar(
            "Error", "Please upload a service image and select a category.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Service'),
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

              // Service Name Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Service Name (English)',
                  hintText: 'Ex. Home Cleaning',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the service name in English';
                  }
                  return null;
                },
                onSaved: (value) {
                  serviceName = value;
                },
              ),
              SizedBox(height: 16),

              // Service Name (Arabic) Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Service Name (Arabic)',
                  hintText: 'Ex. تنظيف المنزل',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the service name in Arabic';
                  }
                  return null;
                },
                onSaved: (value) {
                  serviceNameAr = value;
                },
              ),
              SizedBox(height: 16),

              // Category Dropdown (GetX)
              // Category Dropdown (GetX)
              Obx(() {
                // Check if categories are loaded
                if (adminProvider.categories.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  // Filter categories where type is 'Size Based'
                  List<CategoryModel> filteredCategories = adminProvider
                      .categories
                      .where((category) => category.type == 'Size Based')
                      .toList();

                  return DropdownButtonFormField<CategoryModel>(
                    decoration: InputDecoration(
                      labelText: 'Select Category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    // Map filtered categories to DropdownMenuItems
                    items: filteredCategories.map((category) {
                      return DropdownMenuItem<CategoryModel>(
                        value: category,
                        child: Text(
                          category.categoryType, // Display categoryType
                          style: TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory =
                            value; // Update the selected category
                      });
                    },
                    value: selectedCategory,
                    validator: (value) =>
                        value == null ? 'Please select a category' : null,
                  );
                }
              }),
              SizedBox(height: 16),

              // Price Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Price',
                  hintText: 'Enter price',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      int.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
                onSaved: (value) {
                  price = int.parse(value!);
                },
              ),
              SizedBox(height: 16),

              // Base Size Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Base Size',
                  hintText: 'Enter base size',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      int.tryParse(value) == null) {
                    return 'Please enter a valid base size';
                  }
                  return null;
                },
                onSaved: (value) {
                  baseSize = int.parse(value!);
                },
              ),
              SizedBox(height: 16),

              // Base Price Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Base Price',
                  hintText: 'Enter base price',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      int.tryParse(value) == null) {
                    return 'Please enter a valid base price';
                  }
                  return null;
                },
                onSaved: (value) {
                  basePrice = int.parse(value!);
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
                    onPressed: _saveService, // Call the save function
                    child: Text('Save Service'),
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
