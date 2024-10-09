import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
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
  var categoryList = <CategoryModel>[].obs;
  var products = <UserProductModel>[].obs;
  var services = <ServiceModel>[].obs;
  var isLoading = true.obs;
  var addresses = <AddressModel>[].obs;
  var bookings = <BookingModel>[].obs;
  var cartBookings = <BookingModel>[].obs;

  // Observable properties
  var selectedDate = Rx<DateTime?>(null);
  var selectedServices = <ServiceSummaryModel>[].obs;
  var selectedAddress = Rx<AddressModel?>(null);
  var selectedProducts = <UserProductModel>[].obs;
  var imageString = ''.obs;
  var profileImage = Rx<File?>(null);
  var selectedCategory = Rx<CategoryModel?>(null);
  final ImagePicker _picker = ImagePicker();
  @override
  void onInit() {
    super.onInit();
    loadCartFromPrefs(); // Load cart data when provider is initialized
  }

  // Helper method for service price calculation
  double _calculateServicePrice(int quantity, int size) {
    // Implement your actual pricing logic here
    double basePrice = 100.0; // Base price per service
    return basePrice * quantity * size;
  }

  // Image picking methods
  Future<void> pickImageFromGallery() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
    }
  }

  Future<void> pickImageFromCamera() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
    }
  }

  // Fetch methods
  Future<void> fetchServicesByCategory(String category) async {
    try {
      isLoading.value = true;

      // Fetch services by category
      var snapshot = await FirebaseFirestore.instance
          .collection('services_table')
          .where('category', isEqualTo: category)
          .get();

      // Map snapshot data to ServiceModel list
      services.value = snapshot.docs
          .map((doc) => ServiceModel.fromJson(doc.data()))
          .toList();

      if (services.isEmpty) {
        // Handle case where no services are found for the category
        print("No services found for category: $category");
      }
    } catch (e) {
      print("Error fetching services by category: $e");
    } finally {
      isLoading.value = false;
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

  Future<void> fetchCategories() async {
    try {
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
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id') ?? 121;

      var snapshot = await FirebaseFirestore.instance
          .collection('address_table')
          .where('user_id', isEqualTo: userId)
          .get();

      addresses.value = snapshot.docs
          .map((doc) => AddressModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print("Error fetching addresses: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchBookings() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id') ?? 111;

      var snapshot = await FirebaseFirestore.instance
          .collection('size_based_bookings')
          .where('user_id', isEqualTo: userId)
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

  // Cart-related methods
  Future<void> addToCart() async {
    if (selectedCategory.value == null) {
      Get.snackbar('Error', 'Please select a category',
          backgroundColor: Colors.red);
      return;
    }
    final bookingData = createBookingDocument();
    final booking = BookingModel.fromFirestore(bookingData);
    cartBookings.add(booking);
    await saveCartToPrefs();
    clearSelections(); // This will now also clear the selected category
    Get.offAll(() => UserMain());
    Get.snackbar('Success', 'Added to cart', backgroundColor: Colors.green);
  }

  Future<void> saveCartToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartDataList = cartBookings.map((booking) {
        return {
          'address': booking.address,
          'booking_date': booking.bookingDate,
          'booking_id': booking.booking_id,
          'booking_time': booking.bookingTime,
          'employee_id': booking.employee_id,
          'end_image': booking.endImage,
          'payment_status': booking.payment_status,
          'products': booking.products
              .map((product) => {
                    'product_name': product.product_name,
                    'quantity': product.quantity,
                    'delivery_time': product.delivery_time,
                    'image_url': product.imageUrl
                  })
              .toList(),
          'services': [
            {
              'service_names': booking.services
                  .map((service) => {
                        'service_name': service.service_name,
                        'quantity': service.quantity,
                        'size': service.size,
                      })
                  .toList(),
            }
          ],
          'start_image': booking.start_image,
          'status': booking.status,
          'total_price': booking.total_price,
          'user_id': booking.user_id,
          'user_phn_number': booking.user_phn_number,
          'category_name': booking.categoryName,
          'category_image': booking.categoryImage,
        };
      }).toList();

      final String encodedData = json.encode(cartDataList);
      await prefs.setString('cart_bookings', encodedData);
    } catch (e) {
      print('Error saving cart to SharedPreferences: $e');
    }
  }

  Future<void> loadCartFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? cartDataString = prefs.getString('cart_bookings');

      if (cartDataString != null && cartDataString.isNotEmpty) {
        final List<dynamic> cartDataList = json.decode(cartDataString);
        cartBookings.value = cartDataList
            .map((data) =>
                BookingModel.fromFirestore(data as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      print('Error loading cart from SharedPreferences: $e');
    }
  }

  Future<void> removeFromCart(int index) async {
    cartBookings.removeAt(index);
    await saveCartToPrefs();
  }

  Future<void> clearCart() async {
    cartBookings.clear();
    await saveCartToPrefs();
  }

  Future<void> addProductToCart(UserProductModel product) async {
    final bookingData = createProductBookingDocument(product);
    final booking = BookingModel.fromFirestore(bookingData);
    cartBookings.add(booking);
    await saveCartToPrefs();
    Get.snackbar('Success', '${product.name} added to cart',
        backgroundColor: Colors.green);
  }

  Map<String, dynamic> createProductBookingDocument(UserProductModel product) {
    return {
      'address': 'default address',
      'booking_date': DateTime.now().toString(),
      'booking_id': DateTime.now().millisecondsSinceEpoch,
      'booking_time': DateFormat('h:mm a').format(DateTime.now()),
      'employee_id': 102,
      'end_image': '',
      'payment_status': 'Pending',
      'products': [
        {
          'product_name': product.name,
          'quantity': product.quantity ?? 1,
          'delivery_time': product.deliveryTime ?? '1-2 Days',
          'image_url': product.imageUrl ?? 'https://placeholder.com/100',
          'price': product.price,
        }
      ],
      'services': [],
      'start_image': '',
      'status': 'pending',
      'total_price': product.price * (product.quantity ?? 1),
      'user_id': 111,
      'user_phn_number': '9999999999',
      'category_name': '', // Added with empty string
      'category_image': '', // Added with empty string
    };
  }

  // Booking processing methods
  Future<void> processCartBookings() async {
    try {
      Map<String, List<BookingModel>> bookingsByDate = {};
      for (var booking in cartBookings) {
        String date = booking.bookingDate;
        if (!bookingsByDate.containsKey(date)) {
          bookingsByDate[date] = [];
        }
        bookingsByDate[date]!.add(booking);
      }

      for (var entry in bookingsByDate.entries) {
        if (entry.value.length > 1) {
          await _processCombinedBookings(entry.value);
        } else {
          await saveBookingToFirestore(
              bookingData: createBookingDocument(
            bookingDate: DateTime.parse(entry.value.first.bookingDate),
            services: entry.value.first.services
                .map((s) => ServiceSummaryModel(
                      serviceName: s.service_name,
                      totalQuantity: s.quantity,
                      totalSize: s.size,
                      totalPrice: _calculateServicePrice(s.quantity, s.size),
                    ))
                .toList(),
            products: entry.value.first.products
                .map((p) => UserProductModel(
                      name: p.product_name,
                      quantity: p.quantity,
                      deliveryTime: p.delivery_time,
                      price: 0,
                      imageUrl: '',
                    ))
                .toList(),
          ));
        }
      }

      cartBookings.clear();
      await saveCartToPrefs();
      Get.snackbar('Success', 'All bookings processed successfully',
          backgroundColor: Colors.green);
    } catch (e) {
      print('Error processing cart bookings: $e');
      Get.snackbar('Error', 'Failed to process bookings',
          backgroundColor: Colors.red);
    }
  }

  Future<void> _processCombinedBookings(List<BookingModel> bookings) async {
    List<ServiceSummaryModel> combinedServices = [];
    List<UserProductModel> combinedProducts = [];

    for (var booking in bookings) {
      combinedServices.addAll(booking.services.map((s) => ServiceSummaryModel(
            serviceName: s.service_name,
            totalQuantity: s.quantity,
            totalSize: s.size,
            totalPrice: _calculateServicePrice(s.quantity, s.size),
          )));

      combinedProducts.addAll(booking.products.map((p) => UserProductModel(
            name: p.product_name,
            quantity: p.quantity,
            deliveryTime: p.delivery_time,
            price: 0,
            imageUrl: '',
          )));
    }

    await saveBookingToFirestore(
        bookingData: createBookingDocument(
      bookingDate: DateTime.parse(bookings.first.bookingDate),
      services: combinedServices,
      products: combinedProducts,
    ));
  }

  Future<void> saveBookingToFirestore(
      {Map<String, dynamic>? bookingData}) async {
    try {
      final data = bookingData ?? createBookingDocument();
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('size_based_bookings')
          .add(data);
      clearSelections();
      clearCart();
      print('Booking saved successfully with ID: ${docRef.id}');
    } catch (e) {
      print('Error saving booking: $e');
      rethrow;
    }
  }

  // Booking document creation
  Map<String, dynamic> createBookingDocument({
    DateTime? bookingDate,
    List<ServiceSummaryModel>? services,
    List<UserProductModel>? products,
    AddressModel? address,
  }) {
    return {
      'address':
          address?.floor ?? selectedAddress.value?.floor ?? 'default address',
      'booking_date': bookingDate?.toString() ??
          selectedDate.value?.toString() ??
          DateTime.now().toString(),
      'booking_id': DateTime.now().millisecondsSinceEpoch,
      'booking_time':
          DateFormat('h:mm a').format(bookingDate ?? DateTime.now()),
      'employee_id': 102,
      'end_image': '',
      'payment_status': 'Pending',
      'products': (products ?? selectedProducts)
          .map((product) => {
                'product_name': product.name,
                'quantity': product.quantity ?? 1,
                'delivery_time': product.deliveryTime ?? '1-2 Days',
                'price': product.price,
                'image_url': product.imageUrl
              })
          .toList(),
      'services': [
        {
          'service_names': (services ?? selectedServices)
              .map((service) => {
                    'quantity': service.totalQuantity,
                    'service_name': service.serviceName,
                    'size': service.totalSize,
                    'price': service.totalPrice,
                  })
              .toList(),
        }
      ],
      'start_image': '',
      'status': 'pending',
      'total_price':
          calculateTotalPrice(services: services, products: products),
      'user_id': 111,
      'user_phn_number': '9999999999',
      'category_name': selectedCategory.value?.categoryName ?? '',
      'category_image': selectedCategory.value?.categoryImage ?? '',
    };
  }

  void setSelectedCategory(CategoryModel category) {
    selectedCategory.value = category;
  }

  // Utility methods
  double calculateTotalPrice({
    List<ServiceSummaryModel>? services,
    List<UserProductModel>? products,
  }) {
    double serviceTotal = (services ?? selectedServices)
        .fold(0, (sum, service) => sum + (service.totalPrice ?? 0));
    double productTotal = (products ?? selectedProducts).fold(
        0, (sum, product) => sum + (product.price * (product.quantity ?? 1)));
    return serviceTotal + productTotal;
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
    selectedCategory.value = null;
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
}
