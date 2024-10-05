import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/address_model.dart';
import '../models/bookings_model.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/service_model.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../models/service_summary_model.dart';
import '../screens/user_main.dart';

class UserProvider extends GetxController {
  var categoryList =
      <CategoryModel>[].obs; // Assuming you have this for categories
  var products = <UserProductModel>[].obs;
  var services = <ServiceModel>[].obs;
  var isLoading = true.obs;
  var addresses = <AddressModel>[].obs;
  var bookings = <BookingModel>[].obs;

  // New observable properties
  var selectedDate = Rx<DateTime?>(null);
  var selectedServices = <ServiceSummaryModel>[].obs;
  var selectedAddress = Rx<AddressModel?>(null);
  var selectedProducts = <UserProductModel>[].obs;
  var imageString = ''.obs;

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

      // Ensure each product has proper data with null checks
      products.value = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return UserProductModel.fromFirestore(data);
      }).toList();

      print("Mapped products: ${products.length}");
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

  void printBookings() {
    if (bookings.isEmpty) {
      print("No bookings available.");
      return;
    }

    for (var i = 0; i < bookings.length; i++) {
      var booking = bookings[i];
      print("Booking ${i + 1}:");
      print("  Booking ID: ${booking.booking_id}");
      print("  Date: ${booking.bookingDate}");
      print("  Time: ${booking.bookingTime}");
      print("  Address: ${booking.address}");
      print("  Status: ${booking.status}");
      print("  Payment Status: ${booking.payment_status}");
      print("  Total Price: ${booking.total_price}");

      print("  Products:");
      for (var product in booking.products) {
        print(
            "    - ${product.product_name} (Quantity: ${product.quantity}, Delivery Time: ${product.delivery_time})");
      }

      print("  Services:");
      for (var service in booking.services) {
        print(
            "    - ${service.service_name} (Quantity: ${service.quantity}, Size: ${service.size})");
      }

      print("  User ID: ${booking.user_id}");
      print("  User Phone: ${booking.user_phn_number}");
      print("  Employee ID: ${booking.employee_id}");
      print("----------------------------------------");
    }
  }

  Future<void> fetchBookings() async {
    try {
      isLoading.value = true;

      // Get the user_id from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id') ?? 111;

      if (userId == 0) {
        print("User ID not found in SharedPreferences");
        return;
      }

      var snapshot = await FirebaseFirestore.instance
          .collection('services(size)_products_bookings_table')
          .where('user_id', isEqualTo: userId)
          .get();

      bookings.value = snapshot.docs
          .map((doc) => BookingModel.fromFirestore(doc.data()))
          .toList();

      print("Fetched ${bookings.length} bookings for user $userId");
      printBookings();
    } catch (e) {
      print("Error fetching bookings: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic> createBookingDocument() {
    return {
      'address': selectedAddress.value?.floor ?? 'zoonimar',
      'booking_date': selectedDate.value?.toString() ?? '10 September',
      'booking_id': 110, // You might want to generate this dynamically
      'booking_time': '1 PM',
      'employee_id': 102,
      'end_image': '',
      'payment_status': 'Done',
      'products': selectedProducts
          .map((product) => {
                'product_name': product.name,
                'quantity': product.quantity ?? 1,
                'delivery_time': product.deliveryTime ?? '1-2 Days',
              })
          .toList(),
      'services': [
        {
          'service_names': selectedServices
              .map((service) => {
                    'quantity': service.totalQuantity,
                    'service_name': service.serviceName,
                    'size': service.totalSize,
                  })
              .toList(),
        }
      ],
      'start_image': 'yyyyyy',
      'status': 'pending',
      'total_price':
          400, // You might want to calculate this based on selected services and products
      'user_id': 111,
      'user_phn_number': '9999999999',
    };
  }

  double calculateTotalPrice() {
    double serviceTotal = selectedServices.fold(
        0, (sum, service) => sum + (service.totalPrice ?? 0));
    double productTotal = selectedProducts.fold(
        0, (sum, product) => sum + (product.price * (product.quantity ?? 1)));
    return serviceTotal + productTotal;
  }

  Future<void> saveBookingToFirestore() async {
    try {
      final bookingData = createBookingDocument();

      // Create a new document with an auto-generated ID
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('services(size)_products_bookings_table')
          .add(bookingData);

      print('Booking saved successfully with ID: ${docRef.id}');
      Get.offAll(() => UserMain());
      // You might want to show a success message to the user here
    } catch (e) {
      print('Error saving booking: $e');
      // Handle the error (show a snackbar, dialog, etc.)
    }
  }

  Future<void> processBooking() async {
    await saveBookingToFirestore();
    clearSelections(); // Clear selections after successful booking
    // Navigate to a confirmation screen or show a success message
  }

  void setSelectedDate(DateTime date) {
    selectedDate.value = date;
  }

  void setSelectedServices(List<ServiceSummaryModel> services) {
    selectedServices.value = services;
  }

  void setSelectedAddress(AddressModel address) {
    selectedAddress.value = address;
  }

  void toggleProductSelection(UserProductModel product) {
    if (selectedProducts.contains(product)) {
      selectedProducts.remove(product);
    } else {
      selectedProducts.add(product);
    }
  }

  void updateMyString(String value) {
    imageString.value = value;
  }

  void clearSelections() {
    selectedDate.value = null;
    selectedServices.clear();
    selectedAddress.value = null;
    selectedProducts.clear();
    imageString.value = '';
  }
}
