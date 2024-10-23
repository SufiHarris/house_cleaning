// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:house_cleaning/admin/provider/admin_provider.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:house_cleaning/user/models/category_model.dart';
// import 'package:house_cleaning/general_functions/user_profile_image.dart';

// class AddCategoryScreen extends StatefulWidget {
//   @override
//   _AddCategoryScreenState createState() => _AddCategoryScreenState();
// }

// class _AddCategoryScreenState extends State<AddCategoryScreen> {
//   final _formKey = GlobalKey<FormState>();
//   String? categoryName;
//   String? categoryNameAr;
//   String? categoryType;
//   String? description;
//   String? descriptionAr;

//   final imageController = Get.put(ImageController()); // Image Controller
//   final adminProvider = Get.find<AdminProvider>(); // AdminProvider instance

//   @override
//   void initState() {
//     super.initState();
//     imageController.image = null; // Reset the image when the screen loads
//   }

//   // Save category data
//   void _saveCategory() async {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();

//       if (imageController.image != null) {
//         String imageUrl =
//             await imageController.uploadImageToFirebase(imageController.image!);

//         if (imageUrl.isNotEmpty) {
//           // Prepare the category data using the model
//           CategoryModel newCategory = CategoryModel(
//             categoryId:
//                 '', // Initially set to an empty string; it will be updated in the provider
//             categoryName: categoryName!,
//             categoryNameAr: categoryNameAr!,
//             categoryType: categoryType!,
//             imageUrl: imageUrl,
//             categoryImage: imageUrl,
//             description: description!,
//             descriptionAr: descriptionAr!,
//           );

//           // Call the provider's method to add the category to Firestore
//           await adminProvider.addCategory(newCategory);

//           Get.snackbar("Success", "Category added successfully!");
//           Get.back(); // Go back after saving
//         } else {
//           Get.snackbar("Error", "Image upload failed.");
//         }
//       } else {
//         Get.snackbar("Error", "Please upload a category image.");
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add New Category'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               // Image Upload Section using GetBuilder
//               GestureDetector(
//                 onTap: _pickImage, // Trigger image picker
//                 child: GetBuilder<ImageController>(
//                   init: imageController, // Initialize the ImageController
//                   builder: (controller) {
//                     return CircleAvatar(
//                       radius: 50,
//                       backgroundColor: Colors.grey.shade200,
//                       child: controller.image == null
//                           ? Icon(Icons.add_a_photo,
//                               size: 40, color: Colors.brown)
//                           : ClipOval(
//                               child: Image.file(
//                                 File(controller.image!.path),
//                                 fit: BoxFit.cover,
//                                 width: 100,
//                                 height: 100,
//                               ),
//                             ),
//                     );
//                   },
//                 ),
//               ),
//               SizedBox(height: 16),

//               // Category Name Field
//               TextFormField(
//                 decoration: InputDecoration(
//                   labelText: 'Category Name (English)',
//                   hintText: 'Ex. Cleaning Tools',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter the category name in English';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   categoryName = value;
//                 },
//               ),
//               SizedBox(height: 16),

//               // Category Name (Arabic) Field
//               TextFormField(
//                 decoration: InputDecoration(
//                   labelText: 'Category Name (Arabic)',
//                   hintText: 'Ex. أدوات التنظيف',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter the category name in Arabic';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   categoryNameAr = value;
//                 },
//               ),
//               SizedBox(height: 16),

//               // Category Type Field
//               TextFormField(
//                 decoration: InputDecoration(
//                   labelText: 'Category Type',
//                   hintText: 'Ex. Tools',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter the category type';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   categoryType = value;
//                 },
//               ),
//               SizedBox(height: 16),

//               // Category Description Field (English)
//               TextFormField(
//                 decoration: InputDecoration(
//                   labelText: 'Category Description (English)',
//                   hintText: 'Enter description',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 maxLines: 5,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a category description';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   description = value;
//                 },
//               ),
//               SizedBox(height: 16),

//               // Category Description Field (Arabic)
//               TextFormField(
//                 decoration: InputDecoration(
//                   labelText: 'Category Description (Arabic)',
//                   hintText: 'أدخل الوصف',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 maxLines: 5,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a category description in Arabic';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   descriptionAr = value;
//                 },
//               ),
//               SizedBox(height: 16),

//               // Cancel and Save Buttons
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   OutlinedButton(
//                     onPressed: () {
//                       Get.back(); // Cancel and go back
//                     },
//                     child: Text('Cancel'),
//                     style: OutlinedButton.styleFrom(
//                       side: BorderSide(color: Colors.brown),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: _saveCategory, // Call the save function
//                     child: Text('Save Category'),
//                     style: ElevatedButton.styleFrom(),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Method to pick image (trigger ImageController)
//   void _pickImage() {
//     Get.defaultDialog(
//       title: "Choose Image",
//       content: Column(
//         children: [
//           ElevatedButton.icon(
//             onPressed: () {
//               imageController.pickImageFromCamera();
//               Get.back(); // Close the dialog
//             },
//             icon: Icon(Icons.camera),
//             label: Text("Camera"),
//           ),
//           ElevatedButton.icon(
//             onPressed: () {
//               imageController.pickImageFromGallery();
//               Get.back(); // Close the dialog
//             },
//             icon: Icon(Icons.photo),
//             label: Text("Gallery"),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/admin/provider/admin_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:house_cleaning/user/models/category_model.dart';
import 'package:house_cleaning/general_functions/user_profile_image.dart';

class AddCategoryScreen extends StatefulWidget {
  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  String? categoryName;
  String? categoryNameAr;
  String? categoryType;
  String? description;
  String? descriptionAr;
  String? categoryUsageType; // New variable for usage type
  final imageController = Get.put(ImageController()); // Image Controller
  final adminProvider = Get.find<AdminProvider>(); // AdminProvider instance

  final List<String> usageTypes = [
    'Call Based',
    'Size Based'
  ]; // Options for spinner

  @override
  void initState() {
    super.initState();
    imageController.image = null; // Reset the image when the screen loads
    categoryUsageType = usageTypes.first; // Default value for spinner
  }

  // Save category data
  void _saveCategory() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (imageController.image != null) {
        String imageUrl =
            await imageController.uploadImageToFirebase(imageController.image!);

        if (imageUrl.isNotEmpty) {
          // Prepare the category data using the model
          CategoryModel newCategory = CategoryModel(
            categoryId:
                '', // Initially set to an empty string; it will be updated in the provider
            categoryName: categoryName!,
            categoryNameAr: categoryNameAr!,
            categoryType: categoryType!,
            imageUrl: imageUrl,
            categoryImage: imageUrl,
            description: description!,
            descriptionAr: descriptionAr!,
            type: categoryUsageType!, // Add the usage type here
          );

          // Call the provider's method to add the category to Firestore
          await adminProvider.addCategory(newCategory);

          Get.snackbar("Success", "Category added successfully!");
          Get.back(); // Go back after saving
        } else {
          Get.snackbar("Error", "Image upload failed.");
        }
      } else {
        Get.snackbar("Error", "Please upload a category image.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Category'),
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

              // Category Name Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Category Name (English)',
                  hintText: 'Ex. Cleaning Tools',
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
                decoration: InputDecoration(
                  labelText: 'Category Name (Arabic)',
                  hintText: 'Ex. أدوات التنظيف',
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
                decoration: InputDecoration(
                  labelText: 'Category Type',
                  hintText: 'Ex. Tools',
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

              // Spinner for Usage Type
              DropdownButtonFormField<String>(
                value: categoryUsageType,
                decoration: InputDecoration(
                  labelText: 'Usage Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: usageTypes.map((String usageType) {
                  return DropdownMenuItem<String>(
                    value: usageType,
                    child: Text(usageType),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    categoryUsageType =
                        newValue; // Update the selected usage type
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a usage type';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Category Description Field (English)
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Category Description (English)',
                  hintText: 'Enter description',
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
                decoration: InputDecoration(
                  labelText: 'Category Description (Arabic)',
                  hintText: 'أدخل الوصف',
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
                    onPressed: _saveCategory, // Call the save function
                    child: Text('Save Category'),
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
