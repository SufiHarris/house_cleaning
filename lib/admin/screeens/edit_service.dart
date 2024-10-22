import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/admin/provider/admin_provider.dart';
import 'package:house_cleaning/general_functions/user_profile_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:house_cleaning/user/models/service_model.dart';

class EditServiceScreen extends StatefulWidget {
  final ServiceModel service; // Service passed from the previous screen

  EditServiceScreen({required this.service});

  @override
  _EditServiceScreenState createState() => _EditServiceScreenState();
}

class _EditServiceScreenState extends State<EditServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final adminProvider = Get.find<AdminProvider>(); // AdminProvider instance
  final imageController = Get.put(ImageController()); // Image Controller

  String? serviceName;
  String? serviceNameAr;
  int? price;
  int? baseSize;
  int? basePrice;

  @override
  void initState() {
    super.initState();
    // Initialize form fields with the current service data
    serviceName = widget.service.serviceName;
    serviceNameAr = widget.service.serviceNameAr;
    price = widget.service.price;
    baseSize = widget.service.baseSize;
    basePrice = widget.service.basePrice;

    imageController.image = null; // Reset image selection
  }

  // Update the service in Firestore
  void _updateService() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String imageUrl = widget.service.image; // Use the existing image

      // Upload new image if selected
      if (imageController.image != null) {
        imageUrl =
            await imageController.uploadImageToFirebase(imageController.image!);
      }

      // Create the updated service model
      ServiceModel updatedService = ServiceModel(
        serviceId: widget.service.serviceId, // Retain existing ID
        serviceName: serviceName!,
        serviceNameAr: serviceNameAr!,
        category: widget.service.category,
        categoryAr: widget.service.categoryAr,
        image: imageUrl, // Use new or existing image
        price: price!,
        baseSize: baseSize!,
        basePrice: basePrice!,
      );

      await adminProvider
          .updateService(updatedService); // Update service in Firestore
      Get.snackbar("Success", "Service updated successfully!");
      Get.back(); // Go back to the previous screen
    }
  }

  // Delete the service from Firestore
  void _deleteService() async {
    await adminProvider
        .deleteService(widget.service.serviceId); // Delete service
    Get.snackbar("Success", "Service deleted successfully!");
    Get.back(); // Go back to the previous screen
  }

  // Pick image from camera or gallery
  void _pickImage() {
    Get.defaultDialog(
      title: "Choose Image",
      content: Column(
        children: [
          ElevatedButton.icon(
            onPressed: () {
              imageController.pickImageFromCamera();
              Get.back(); // Close dialog
            },
            icon: Icon(Icons.camera),
            label: Text("Camera"),
          ),
          ElevatedButton.icon(
            onPressed: () {
              imageController.pickImageFromGallery();
              Get.back(); // Close dialog
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
        title: Text('Edit Service'),
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
                  init: imageController, // Initialize ImageController
                  builder: (controller) {
                    return CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey.shade200,
                      child: controller.image == null
                          ? ClipOval(
                              child: Image.network(
                                widget.service.image,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.image_not_supported);
                                },
                              ),
                            )
                          : ClipOval(
                              child: Image.file(
                                File(controller.image!.path),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),

              // Service Name Field (English)
              TextFormField(
                initialValue: serviceName,
                decoration: InputDecoration(
                  labelText: 'Service Name (English)',
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

              // Service Name Field (Arabic)
              TextFormField(
                initialValue: serviceNameAr,
                decoration: InputDecoration(
                  labelText: 'Service Name (Arabic)',
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

              // Price Field
              TextFormField(
                initialValue: price.toString(),
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || int.tryParse(value) == null) {
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
                initialValue: baseSize.toString(),
                decoration: InputDecoration(
                  labelText: 'Base Size',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || int.tryParse(value) == null) {
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
                initialValue: basePrice.toString(),
                decoration: InputDecoration(
                  labelText: 'Base Price',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || int.tryParse(value) == null) {
                    return 'Please enter a valid base price';
                  }
                  return null;
                },
                onSaved: (value) {
                  basePrice = int.parse(value!);
                },
              ),
              SizedBox(height: 16),

              // Edit and Delete Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _deleteService, // Delete service
                    child: Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _updateService, // Update service
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
