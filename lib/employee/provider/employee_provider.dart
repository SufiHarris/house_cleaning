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
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // await prefs.setString('staffDetails', jsonEncode(newStaff.toMap()));
      // await prefs.setString('staffDocId', uid); // Save the document ID

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
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // String? staffDetailsJson = prefs.getString('staffDetails');
      // if (staffDetailsJson != null) {
      //   Map<String, dynamic> staffMap = jsonDecode(staffDetailsJson);
      //   staffMap
      //       .addAll(updatedData); // Merge the updated data with existing data
      //   await prefs.setString('staffDetails', jsonEncode(staffMap));
      // }

      print("Staff updated successfully with UID: $uid");
    } catch (e) {
      print("Error updating staff: $e");
    }
  }

  Future<void> deleteStaff(String uid) async {
    try {
      // Step 1: Get the currently authenticated user
      User? user = FirebaseAuth.instance.currentUser;

      // Check if the user to be deleted is the currently logged-in user
      if (user != null && user.uid == uid) {
        // Delete staff from Firebase Auth
        await user.delete();
        print("Staff deleted from Firebase Auth");
      } else {
        // If the user is not the currently logged-in user, delete only from Firestore
        print(
            "Deleting user from Firebase Auth is not required for this operation");
      }

      // Step 2: Delete staff document from Firestore
      await FirebaseFirestore.instance
          .collection('staff_table')
          .doc(uid)
          .delete();
      print("Staff deleted from Firestore");

      // Step 3: Remove staff details from SharedPreferences if necessary
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // await prefs.remove('staffDetails');
      // await prefs.remove('staffDocId');

      print("Staff deleted successfully from SharedPreferences");
    } catch (e) {
      print("Error deleting staff: $e");
    }
  }
}
