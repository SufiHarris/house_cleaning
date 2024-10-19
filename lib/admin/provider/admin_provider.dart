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

  Future<void> fetchBookings(int year) async {
    try {
      isLoading.value = true;

      var snapshot = await FirebaseFirestore.instance
          .collection('size_based_bookings')
          .where('booking_date', isGreaterThanOrEqualTo: '$year-01-01')
          .where('booking_date', isLessThan: '${year + 1}-01-01')
          .get();

      bookings.value = snapshot.docs
          .map((doc) => BookingModel.fromFirestore(doc.data()))
          .toList();

      print("Fetched ${bookings.length} bookings for year $year");
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

  // Method to add a product to Firestore (updated to accept dynamic data)
  Future<void> addProduct(UserProductModel newProduct) async {
    try {
      // Convert the product object to JSON
      Map<String, dynamic> productData = newProduct.toJson();
      productData.remove('product_id'); // Remove product_id for now

      // Add the product to Firestore
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('product_table')
          .add(productData);

      // Get the document ID and update product_id
      String generatedDocId = docRef.id;
      await FirebaseFirestore.instance
          .collection('product_table')
          .doc(generatedDocId)
          .update({'product_id': generatedDocId});

      print("Product added successfully with ID: $generatedDocId");
    } catch (e) {
      print("Error adding product: $e");
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

  Map<String, int> getBookingCounts() {
    int completed = 0;
    int inProcess = 0;
    int unAssigned = 0;
    int cancelled = 0;

    for (var booking in bookings) {
      switch (booking.status.toLowerCase()) {
        case 'completed':
          completed++;
          break;
        case 'in-process':
          inProcess++;
          break;
        case 'unassigned':
          unAssigned++;
          break;
        case 'cancelled':
          cancelled++;
          break;
      }
    }

    return {
      'completed': completed,
      'inProcess': inProcess,
      'unAssigned': unAssigned,
      'cancelled': cancelled,
    };
  }
}
