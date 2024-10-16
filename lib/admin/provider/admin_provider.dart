import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/auth/model/staff_model.dart';

import '../../auth/model/usermodel.dart';
import '../../user/models/bookings_model.dart';
import '../../user/models/product_model.dart';

class AdminProvider extends GetxController {
  var bookings = <BookingModel>[].obs;
  var employees = <StaffModel>[].obs;
  var usersList = <UserModel>[].obs;
  var products = <UserProductModel>[].obs;

  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEmployees();
  }

  Future<void> fetchBookings() async {
    try {
      isLoading.value = true;

      var snapshot = await FirebaseFirestore.instance
          .collection('size_based_bookings')
          // Use userId here
          .get();
      bookings.value = snapshot.docs
          .map((doc) => BookingModel.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      print("Error fetching bookings: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchEmployees() async {
    print("Starting fetchEmployees method");
    try {
      // Adding a filter to only fetch employees whose role is not 'admin'
      var snapshot = await FirebaseFirestore.instance
          .collection('staff_table')
          .where('role', isNotEqualTo: 'admin')
          .get();

      print("Fetched ${snapshot.docs.length} employee documents");

      employees.value = snapshot.docs.map((doc) {
        print("Processing document: ${doc.id}");
        return StaffModel.fromFirestore(doc.data());
      }).toList();

      print("Processed ${employees.length} employees");
      print(
          "First employee: ${employees.isNotEmpty ? employees[0].toString() : 'None'}");
    } catch (e) {
      print("Error fetching employees: $e");
    }
  }

  Future<void> fetchUsers() async {
    try {
      var snapshot =
          await FirebaseFirestore.instance.collection('users_table').get();

      usersList.value = snapshot.docs.map((doc) {
        return UserModel.fromFirestore(doc.data());
      }).toList();
      print("Processed ${usersList.length} employees");
    } catch (e) {
      print("Error fetching employees: $e");
    }
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      var snapshot =
          await FirebaseFirestore.instance.collection('product_table').get();
      products.value = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return UserProductModel.fromFirestore(data);
      }).toList();
    } catch (e) {
      print("Error fetching products: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
