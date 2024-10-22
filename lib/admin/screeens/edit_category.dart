import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/admin/provider/admin_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:house_cleaning/user/models/category_model.dart';
import 'package:house_cleaning/general_functions/user_profile_image.dart';

class EditCategoryScreen extends StatefulWidget {
  final CategoryModel category;

  EditCategoryScreen({required this.category});

  @override
  _EditCategoryScreenState createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  String? categoryName;
  String? categoryNameAr;
  String? categoryType;
  String? description;
  String? descriptionAr;

  final imageController = Get.put(ImageController());
  final adminProvider = Get.find<AdminProvider>();

  @override
  void initState() {
    super.initState();
    imageController.image = null;

    // Initialize fields with current category data
    categoryName = widget.category.categoryName;
    categoryNameAr = widget.category.categoryNameAr;
    categoryType = widget.category.categoryType;
    description = widget.category.description;
    descriptionAr = widget.category.descriptionAr;
  }

  void _editCategory() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String imageUrl = widget.category.imageUrl;

      if (imageController.image != null) {
        imageUrl =
            await imageController.uploadImageToFirebase(imageController.image!);
      }

      CategoryModel updatedCategory = CategoryModel(
        categoryId: widget.category.categoryId, // Make sure to use categoryId
        categoryName: categoryName!,
        categoryNameAr: categoryNameAr!,
        categoryType: categoryType!,
        imageUrl: imageUrl,
        categoryImage: imageUrl,
        description: description!,
        descriptionAr: descriptionAr!,
      );

      try {
        await adminProvider.updateCategory(
            widget.category.categoryId, updatedCategory);
        Get.snackbar("Success", "Category updated successfully!");
        Get.back();
      } catch (e) {
        Get.snackbar("Error", "Failed to update category: $e");
      }
    }
  }

  void _deleteCategory() async {
    try {
      await adminProvider.deleteCategory(widget.category.categoryId);
      Get.snackbar("Success", "Category deleted successfully!");
      Get.back();
    } catch (e) {
      Get.snackbar("Error", "Failed to delete category: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Category'),
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
                  init: imageController,
                  builder: (controller) {
                    return CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey.shade200,
                      child: controller.image == null
                          ? ClipOval(
                              child: Image.network(
                                widget.category.imageUrl,
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
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

              // Category Name Field
              TextFormField(
                initialValue: categoryName,
                decoration: InputDecoration(
                  labelText: 'Category Name (English)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the category name in English';
                  }
                  return null;
                },
                onSaved: (value) {
                  categoryName = value;
                },
              ),
              SizedBox(height: 16),

              // Category Name (Arabic) Field
              TextFormField(
                initialValue: categoryNameAr,
                decoration: InputDecoration(
                  labelText: 'Category Name (Arabic)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the category name in Arabic';
                  }
                  return null;
                },
                onSaved: (value) {
                  categoryNameAr = value;
                },
              ),
              SizedBox(height: 16),

              // Category Type Field
              TextFormField(
                initialValue: categoryType,
                decoration: InputDecoration(
                  labelText: 'Category Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the category type';
                  }
                  return null;
                },
                onSaved: (value) {
                  categoryType = value;
                },
              ),
              SizedBox(height: 16),

              // Category Description Field (English)
              TextFormField(
                initialValue: description,
                decoration: InputDecoration(
                  labelText: 'Category Description (English)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category description';
                  }
                  return null;
                },
                onSaved: (value) {
                  description = value;
                },
              ),
              SizedBox(height: 16),

              // Category Description Field (Arabic)
              TextFormField(
                initialValue: descriptionAr,
                decoration: InputDecoration(
                  labelText: 'Category Description (Arabic)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category description in Arabic';
                  }
                  return null;
                },
                onSaved: (value) {
                  descriptionAr = value;
                },
              ),
              SizedBox(height: 16),

              // Edit and Delete Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: _deleteCategory, // Call the delete function
                    child: Text('Delete'),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.red),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _editCategory, // Call the edit function
                    child: Text('Edit Changes'),
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
