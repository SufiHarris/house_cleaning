// lib/controllers/image_controller.dart

import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageController extends GetxController {
  File? _image;
  File? get image => _image;

  // Add a setter to reset the image
  set image(File? file) {
    _image = file;
    update(); // Ensure the UI updates
  }

  // Method to upload image to Firebase Storage and return the download URL
  Future<String> uploadImageToFirebase(File imageFile) async {
    try {
      // Create a reference in Firebase Storage
      Reference storageReference = FirebaseStorage.instance.ref().child(
          'user_profile_images/${DateTime.now().millisecondsSinceEpoch}.png');

      // Upload the file
      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;

      // Get and return the download URL
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      Get.snackbar(
        "Error",
        "Failed to upload image. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return "";
    }
  }

  Future<void> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      update();

      String imageUrl = await uploadImageToFirebase(_image!);
      if (imageUrl.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userDetails = prefs.getString('userDetails');
        if (userDetails != null) {
          Map<String, dynamic> userMap = jsonDecode(userDetails);
          userMap['image'] = imageUrl;
          await prefs.setString('userDetails', jsonEncode(userMap));
        }
      }
    }
  }

  Future<void> pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      update();

      String imageUrl = await uploadImageToFirebase(_image!);

      if (imageUrl.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userDetails = prefs.getString('userDetails');
        if (userDetails != null) {
          Map<String, dynamic> userMap = jsonDecode(userDetails);
          userMap['image'] = imageUrl;
          await prefs.setString('userDetails', jsonEncode(userMap));
        }
      }
    }
  }
}
