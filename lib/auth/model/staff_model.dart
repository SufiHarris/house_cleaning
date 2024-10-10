// staff_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StaffModel {
  final String name;
  final String email;
  final String password;
  final int phoneNumber;
  final String employeeId;
  final String image;
  final String role;
  final int age;
  final int emergencyPhoneNumber;

  StaffModel({
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.employeeId,
    required this.image,
    required this.role,
    required this.age,
    required this.emergencyPhoneNumber,
  });

  // Factory method to create a StaffModel from Firestore data
  factory StaffModel.fromFirestore(Map<String, dynamic> data) {
    return StaffModel(
      name: data['name'],
      email: data['email'],
      password: data['password'],
      phoneNumber: data['phone_number'] ?? "",
      employeeId: data['employee_id'] ?? "",
      image: data['image'] ?? "",
      role: data['role'] ?? "",
      age: data['age'] ?? 0,
      emergencyPhoneNumber: data['emergency_phn_number'] ?? "",
    );
  }

  // Convert to map for saving in SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'phone_number': phoneNumber,
      'employee_id': employeeId,
      'image': image,
      'role': role,
      'age': age,
      'emergency_phn_number': emergencyPhoneNumber,
    };
  }
}

Future<void> saveStaffDetailsLocally(String email) async {
  try {
    // Fetch staff details from Firestore using email
    var staffDoc = await FirebaseFirestore.instance
        .collection('staff_table')
        .where('email', isEqualTo: email)
        .get();

    if (staffDoc.docs.isNotEmpty) {
      var staffData = staffDoc.docs.first.data();
      String docId = staffDoc.docs.first.id; // Get the document ID
      StaffModel staff = StaffModel.fromFirestore(staffData);

      // Save staff details in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String staffJson = jsonEncode(staff.toMap());
      await prefs.setString('staffDetails', staffJson);
      await prefs.setString('staffDocId', docId); // Save the document ID
      print('Staff details saved successfully: ${staffJson}');
    } else {
      print("No staff found with this email.");
    }
  } catch (e) {
    print("Error saving staff details: $e");
  }
}

Future<StaffModel?> getStaffDetailsFromLocal() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? staffDetails = prefs.getString('staffDetails');

  if (staffDetails != null) {
    // Convert the string back to Map and then to StaffModel
    Map<String, dynamic> staffMap = jsonDecode(staffDetails);
    try {
      StaffModel staff = StaffModel.fromFirestore(staffMap);
      print('Successfully decoded StaffModel: ${staff.name}');
      return staff;
    } catch (e) {
      print('Error decoding StaffModel: $e');
      return null;
    }
  } else {
    print('No staff details found in SharedPreferences');
  }

  return null;
}
