// staff_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Staff {
  final String id;
  final String email;
  final String name;
  final String password;
  final int age;
  final String phoneNumber;
  final String emergencyPhoneNumber;
  final String image;
  final String role;
  final int employeeId;

  Staff({
    required this.id,
    required this.email,
    required this.name,
    required this.password,
    required this.age,
    required this.phoneNumber,
    required this.emergencyPhoneNumber,
    required this.image,
    required this.role,
    required this.employeeId,
  });

  // Factory method to create a Staff object from a Firestore document
  factory Staff.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Staff(
      id: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      password: data['password'] ?? '',
      age: data['age'] ?? 0,
      phoneNumber: data['phone_number'] ?? '',
      emergencyPhoneNumber: data['emergency_phn_number'] ?? '',
      image: data['image'] ?? '',
      role: data['role'] ?? 'user',
      employeeId: data['employee_id'] ?? 0,
    );
  }

  // Convert Staff object to Map (for Firestore updates or SharedPreferences)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'password': password,
      'age': age,
      'phone_number': phoneNumber,
      'emergency_phn_number': emergencyPhoneNumber,
      'image': image,
      'role': role,
      'employee_id': employeeId,
    };
  }

  // Factory method to create a Staff object from a Map (for SharedPreferences)
  factory Staff.fromMap(Map<String, dynamic> data) {
    return Staff(
      id: data['id'] ?? '',
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      password: data['password'] ?? '',
      age: data['age'] ?? 0,
      phoneNumber: data['phone_number'] ?? '',
      emergencyPhoneNumber: data['emergency_phn_number'] ?? '',
      image: data['image'] ?? '',
      role: data['role'] ?? 'user',
      employeeId: data['employee_id'] ?? 0,
    );
  }
}
