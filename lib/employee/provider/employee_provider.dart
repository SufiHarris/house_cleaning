import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/model/staff_model.dart';
import '../../user/models/bookings_model.dart';

class EmployeeProvider extends GetxController {
  // ... other properties ...

  Rx<StaffModel?> staffDetails = Rx<StaffModel?>(null);
  RxString employeeId = ''.obs;
  var employeeBookings = <BookingModel>[].obs;

  // ... other methods ...

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

      // Fetch bookings from Firestore where employee_id matches the userId
      var snapshot = await FirebaseFirestore.instance
          .collection('size_based_bookings')
          .where('employee_id', isEqualTo: 102) // assuming employee_id is int
          .get();

      // Map the fetched documents to BookingModel and store in the observable list
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
}
