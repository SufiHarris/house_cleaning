import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/address_model.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/service_model.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../screens/user_main.dart';

class UserProvider extends GetxController {
  Future<void> saveUserProfile({
    required String email,
    required String name,
    required String phone,
    required String password,
  }) async {
    try {
      // Step 1: Register the user
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Check if userCredential is valid
      if (userCredential.user == null) {
        Get.snackbar("Error", "Failed to register user");
        return;
      }

      // Step 2: Save user data in Firestore
      String uid = userCredential.user!.uid; // Get the user's UID

      await FirebaseFirestore.instance.collection('users_table').doc(uid).set({
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'user_id': 3, // Ensure this is correct based on your logic
      });

      Get.snackbar("Success", "Profile created successfully!");
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Authentication errors
      print("Firebase Auth error: ${e.message}");
      Get.snackbar(
          "Error", e.message ?? "An error occurred during authentication");
    } on FirebaseException catch (e) {
      // Handle Firestore errors
      print("Firestore error: ${e.message}");
      Get.snackbar("Error", "Failed to save data to Firestore: ${e.message}");
    } catch (e) {
      // Handle any other errors
      print("General error: $e");
      Get.snackbar("Error", "An unexpected error occurred");
    }
  }

  var categoryList =
      <CategoryModel>[].obs; // Assuming you have this for categories
  var products = <UserProductModel>[].obs;
  var services = <ServiceModel>[].obs;
  var isLoading = true.obs;
  var addresses = <AddressModel>[].obs;

  var profileImage = Rx<File?>(null); // Observable for the profile image
  final ImagePicker _picker = ImagePicker();

  // Function to pick image from gallery
  Future<void> pickImageFromGallery() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
    }
  }

  // Function to pick image from camera
  Future<void> pickImageFromCamera() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
    }
  }

  Future<void> fetchServicesByCategory(String category) async {
    try {
      isLoading.value = true; // Start loading indicator
      var snapshot = await FirebaseFirestore.instance
          .collection('services_table')
          .where('category',
              isEqualTo: category) // Firestore query to filter by category
          .get();

      // Map the Firestore documents to ServiceModel and update the services list
      services.value = snapshot.docs
          .map((doc) => ServiceModel.fromJson(doc.data()))
          .toList();
      print(services.value);
    } catch (e) {
      print("Error fetching services by category: $e");
    } finally {
      print("data fethced");
      isLoading.value = false; // Stop loading indicator
    }
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      var snapshot =
          await FirebaseFirestore.instance.collection('product_table').get();
      products.value = snapshot.docs
          .map((doc) => UserProductModel.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      print("Error fetching products: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCategories() async {
    try {
      // Fetch data from Firestore
      final snapshot =
          await FirebaseFirestore.instance.collection('category_table').get();
      categoryList.value = snapshot.docs
          .map((doc) => CategoryModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  Future<void> fetchAddresses() async {
    try {
      isLoading.value = true; // Set loading to true

      // Get the user_id from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userId = 1;

      if (userId == 0) {
        print("User ID not found in SharedPreferences");
        return;
      }

      // Fetch addresses from Firestore
      var snapshot = await FirebaseFirestore.instance
          .collection('address_table')
          .where('user_id', isEqualTo: userId)
          .get();
      print("Fetched ${snapshot.docs.length} addresses for user $userId");

      // Map the Firestore documents to AddressModel and update the addresses list
      addresses.value = snapshot.docs
          .map((doc) => AddressModel.fromJson(doc.data()))
          .toList();

      print("Fetched ${addresses.length} addresses for user $userId");
    } catch (e) {
      print("Error fetching addresses: $e");
    } finally {
      isLoading.value = false; // Set loading to false after fetching
    }
  }
}
