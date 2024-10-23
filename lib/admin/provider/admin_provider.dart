import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/auth/model/staff_model.dart';
import 'package:house_cleaning/user/models/category_model.dart';
import 'package:house_cleaning/user/models/service_model.dart';

import '../../auth/model/usermodel.dart';
import '../../user/models/bookings_model.dart';
import '../../user/models/product_model.dart';

class AdminProvider extends GetxController {
  var bookings = <BookingModel>[].obs;
  var employees = <StaffModel>[].obs;
  var usersList = <UserModel>[].obs;
  var products = <UserProductModel>[].obs;
  var categories = <CategoryModel>[].obs;
  var services = <ServiceModel>[].obs;

  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEmployees();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
        case 'assigned':
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

  //Mark:- Category Methods...
  Future<void> assignEmployeesToBooking(
      String bookingId, List<String> employeeIds) async {
    print("Booking ID is here: $bookingId");
    try {
      // Query the document with the provided bookingId
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('size_based_bookings')
          .where('booking_id', isEqualTo: bookingId)
          .get();

      // If the document is found, update it
      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs.first.id;

        // Update the document with new employee IDs
        await FirebaseFirestore.instance
            .collection('size_based_bookings')
            .doc(docId)
            .update({'employee_ids': employeeIds, 'status': 'assigned'});

        print('Successfully assigned employees to booking.');
      } else {
        print('Booking not found for bookingId: $bookingId');
        throw Exception('Booking not found');
      }
    } catch (e) {
      print('Error assigning employees: $e');
      throw e;
    }
  }

// Fetch categories from Firestore
  Future<void> fetchCategories() async {
    try {
      var snapshot =
          await FirebaseFirestore.instance.collection('category_table').get();

      categories.value = snapshot.docs.map((doc) {
        // Convert Firestore document data to CategoryModel
        return CategoryModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      print("Fetched ${categories.length} categories");
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

//Add Categor Method..
  Future<void> addCategory(CategoryModel newCategory) async {
    try {
      // Convert the category object to JSON without the categoryId
      Map<String, dynamic> categoryData = newCategory.toJson();

      // Add the category to Firestore collection 'category_table' and get the document reference
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('category_table')
          .add(categoryData);

      // Now, update the category data with the generated ID
      newCategory = CategoryModel(
        categoryId: docRef.id, // Use the generated ID from Firestore
        categoryName: newCategory.categoryName,
        categoryNameAr: newCategory.categoryNameAr,
        categoryType: newCategory.categoryType,
        imageUrl: newCategory.imageUrl,
        categoryImage: newCategory.categoryImage,
        description: newCategory.description,
        descriptionAr: newCategory.descriptionAr,
        type: newCategory.type,
      );

      // Update the Firestore document with the categoryId
      await docRef.update(
          {'id': newCategory.categoryId}); // Set the id field in Firestore

      // Optionally, update the local list after adding to Firestore
      categories.add(newCategory);

      print("Category added successfully: $newCategory");
    } catch (e) {
      print("Error adding category: $e");
      Get.snackbar("Error", "Failed to add category.");
    }
  }

// Update category method
  Future<void> updateCategory(
      String categoryId, CategoryModel updatedCategory) async {
    try {
      await _firestore
          .collection('category_table')
          .doc(categoryId)
          .update(updatedCategory.toJson());
      print("Category updated successfully.");
    } catch (e) {
      print("Error updating category: $e");
      throw e; // Propagate error for further handling if necessary
    }
  }

  // Delete category method
  Future<void> deleteCategory(String categoryId) async {
    try {
      await _firestore.collection('category_table').doc(categoryId).delete();
      print("Category deleted successfully.");
    } catch (e) {
      print("Error deleting category: $e");
      throw e; // Propagate error for further handling if necessary
    }
  }

//Mark:- Service Methods..

  // Fetch Services
  Future<void> fetchServices() async {
    try {
      var snapshot =
          await FirebaseFirestore.instance.collection('services_table').get();

      // Safely map Firestore documents to ServiceModel
      services.value = snapshot.docs.map((doc) {
        // Ensure that if some fields are missing or of the wrong type, it still maps correctly
        return ServiceModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      print("Fetched ${services.length} services.");
    } catch (e) {
      print("Error fetching services: $e");
    }
  }

//Adding Service.
  Future<void> addService(ServiceModel newService) async {
    try {
      Map<String, dynamic> serviceData = newService.toJson();
      serviceData.remove('service_id'); // Remove serviceId for now

      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('services_table')
          .add(serviceData);

      String generatedDocId = docRef.id;
      await FirebaseFirestore.instance
          .collection('services_table')
          .doc(generatedDocId)
          .update({'service_id': generatedDocId});

      print("Service added successfully with ID: $generatedDocId");
    } catch (e) {
      print("Error adding service: $e");
    }
  }

// In AdminProvider class
  Future<void> updateService(ServiceModel updatedService) async {
    try {
      await _firestore
          .collection('services_table')
          .doc(updatedService.serviceId) // Use the serviceId as document ID
          .update(updatedService.toJson());

      print("Service updated successfully!");
      Get.snackbar("Success", "Service updated successfully!");
    } catch (e) {
      print("Error updating service: $e");
      Get.snackbar("Error", "Failed to update service.");
    }
  }

  Future<void> deleteService(String serviceId) async {
    try {
      await _firestore.collection('services_table').doc(serviceId).delete();
      print("Service deleted successfully!");
      Get.snackbar("Success", "Service deleted successfully!");
    } catch (e) {
      print("Error deleting service: $e");
      Get.snackbar("Error", "Failed to delete service.");
    }
  }
}
