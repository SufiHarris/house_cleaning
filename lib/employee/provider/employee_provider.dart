import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/user/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/model/staff_model.dart';
import '../../user/models/bookings_model.dart';

class EmployeeProvider extends GetxController {
  // ... other properties ...

  Rx<StaffModel?> staffDetails = Rx<StaffModel?>(null);
  RxString employeeId = ''.obs;
  var employeeBookings = <BookingModel>[].obs;

  Future<void> loadStaffDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? staffDetailsJson = prefs.getString('staffDetails');
    if (staffDetailsJson != null) {
      Map<String, dynamic> staffMap = jsonDecode(staffDetailsJson);
      staffDetails.value = StaffModel.fromFirestore(staffMap);
      employeeId.value = staffDetails.value?.employeeId ?? '';
    }
  }

  Future<void> fetchEmployeeBookings() async {
    try {
      // if (userId.value.isEmpty) {
      //   print('User ID is not available');
      //   return;
      // }

      var snapshot = await FirebaseFirestore.instance
          .collection('size_based_bookings')
          .where('employee_id', isEqualTo: 102)
          .get();

      employeeBookings.value = snapshot.docs
          .map((doc) => BookingModel.fromFirestore(doc.data()))
          .toList();

      if (employeeBookings.isNotEmpty) {
        print('Fetched ${employeeBookings.length} employee bookings');
      } else {
        print('No bookings found for this employee');
      }
    } catch (e) {
      print('Error fetching employee bookings: $e');
    }
  }

// Function to add staff
  // Function to add staff with dynamic data
  Future<void> addStaff(
    String name,
    String email,
    int phoneNumber,
    String password,
    String role,
    int age,
    int emergencyPhoneNumber,
    String imageUrl,
  ) async {
    try {
      // Step 1: Create user in Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Get UID from Firebase Auth, use as employeeId
      String uid = userCredential.user!.uid;

      // Step 2: Create StaffModel object
      StaffModel newStaff = StaffModel(
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
        employeeId: uid,
        role: role,
        age: age,
        emergencyPhoneNumber: emergencyPhoneNumber,
        image: imageUrl,
      );

      // Step 3: Save to Firestore using UID as document ID
      await FirebaseFirestore.instance
          .collection('staff_table')
          .doc(uid)
          .set(newStaff.toMap());

      // Save details locally in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('staffDetails', jsonEncode(newStaff.toMap()));
      await prefs.setString('staffDocId', uid); // Save the document ID

      Get.snackbar("Success", "Staff added successfully with UID: $uid");
    } catch (e) {
      Get.snackbar("Error", "Error adding staff: $e");
    }
  }

// Function to update staff details
  Future<void> updateStaff(String uid, Map<String, dynamic> updatedData) async {
    try {
      // Update the staff document in Firestore
      await FirebaseFirestore.instance
          .collection('staff_table')
          .doc(uid)
          .update(updatedData);

      // Optionally update the local SharedPreferences if necessary
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? staffDetailsJson = prefs.getString('staffDetails');
      if (staffDetailsJson != null) {
        Map<String, dynamic> staffMap = jsonDecode(staffDetailsJson);
        staffMap
            .addAll(updatedData); // Merge the updated data with existing data
        await prefs.setString('staffDetails', jsonEncode(staffMap));
      }

      print("Staff updated successfully with UID: $uid");
    } catch (e) {
      print("Error updating staff: $e");
    }
  }

  // Function to delete staff
  Future<void> deleteStaff(String uid) async {
    try {
      // Step 1: Delete staff from Firebase Auth
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && user.uid == uid) {
        await user.delete();
        print("Staff deleted from Firebase Auth");
      }

      // Step 2: Delete staff document from Firestore
      await FirebaseFirestore.instance
          .collection('staff_table')
          .doc(uid)
          .delete();
      print("Staff deleted from Firestore");

      // Step 3: Remove staff details from SharedPreferences if necessary
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('staffDetails');
      await prefs.remove('staffDocId');

      print("Staff deleted successfully from SharedPreferences");
    } catch (e) {
      print("Error deleting staff: $e");
    }
  }

// Function to add a product to Firestore (product_table)
  Future<void> addProduct() async {
    // Dummy product data for now (without productId, as it will be set after adding)
    UserProductModel newProduct = UserProductModel(
      name: "Sample Product 88",
      imageUrl: "https://via.placeholder.com/150",
      price: 199.99,
      brand: "Sample Brand 88",
      deliveryTime: "2-3 days",
      description: "This is a sample product description.",
      productId:
          null, // We will set this later after getting Firestore's document ID
      quantity: 10,
    );

    try {
      // Step 1: Convert the product object to JSON (excluding the productId for now)
      Map<String, dynamic> productData = newProduct.toJson();
      productData.remove(
          'product_id'); // Remove product_id since we will update it later

      // Step 2: Add the product to Firestore under the 'product_table' collection
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('product_table')
          .add(productData);

      // Step 3: Get the document ID and update the productId field
      String generatedDocId = docRef.id;

      // Step 4: Update the Firestore document to include the productId (doc ID)
      await FirebaseFirestore.instance
          .collection('product_table')
          .doc(generatedDocId)
          .update({'product_id': generatedDocId});

      print("Product added successfully with ID: $generatedDocId");
    } catch (e) {
      print("Error adding product to Firestore: $e");
    }
  }

  Future<void> updateProduct(UserProductModel updatedProduct) async {
    try {
      // Ensure that the productId is not null, as we need it for the document reference
      if (updatedProduct.productId == null) {
        throw Exception("Product ID is required to update the product");
      }

      // Convert the updated product object to JSON
      Map<String, dynamic> updatedData = updatedProduct.toJson();

      // Step 1: Access the Firestore collection and update the document
      await FirebaseFirestore.instance
          .collection('product_table')
          .doc(updatedProduct.productId
              .toString()) // Use the productId (Firestore document ID)
          .update(updatedData);

      print(
          "Product with ID ${updatedProduct.productId} updated successfully!");
    } catch (e) {
      print("Error updating product: $e");
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      // Step 1: Access the Firestore collection and delete the document by its ID
      await FirebaseFirestore.instance
          .collection('product_table')
          .doc(productId) // Use the document ID to delete the product
          .delete();

      print("Product with ID $productId deleted successfully!");
    } catch (e) {
      print("Error deleting product: $e");
    }
  }
}
