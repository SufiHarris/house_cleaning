import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:house_cleaning/user/models/review_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../../auth/model/staff_model.dart';
import '../../auth/model/usermodel.dart';
import '../models/bookings_model.dart';
import '../models/call_booking.dart';
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
  List<StaffModel> allEmployees = [];

  // Observable properties
  var selectedDate = Rx<DateTime?>(null);
  var selectedServices = <ServiceSummaryModel>[].obs;
  var selectedAddress = Rx<AddressModel?>(null);
  var selectedProducts = <UserProductModel>[].obs;
  var imageString = ''.obs;
  final RxList<String> selectedShifts = <String>[].obs;
  final RxList<String> availableShifts = <String>[].obs;
  var profileImage = Rx<File?>(null);
  var selectedCategory = Rx<CategoryModel?>(null);
  final ImagePicker _picker = ImagePicker();
  var userAddresses = <AddressModel>[].obs; // Observable list for addresses
  // final prefs = await SharedPreferences.getInstance();
  // final userId = prefs.getString('userDocId') ?? '';
  var reviews = <Review>[].obs; // Observable list of reviews

  var userId = ''.obs;
  @override
  void onInit() {
    super.onInit();
    _getUserId();
    loadCartFromPrefs();
  }

  void toggleShift(String shift) {
    if (selectedShifts.contains(shift)) {
      selectedShifts.remove(shift);
    } else {
      selectedShifts.add(shift);
    }
  }

  void updateAvailableShifts(List<String> shifts) {
    availableShifts.value = shifts;
  }

  // Helper method for service price calculation
  double _calculateServicePrice(int quantity, int size) {
    // Implement your actual pricing logic here
    double basePrice = 100.0; // Base price per service
    return basePrice * quantity * size;
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

      allEmployees = snapshot.docs.map((doc) {
        print("Processing document: ${doc.id}");
        return StaffModel.fromFirestore(doc.data());
      }).toList();

      print("Processed ${allEmployees.length} employees");
      print(
          "First employee: ${allEmployees.isNotEmpty ? allEmployees[0].toString() : 'None'}");
    } catch (e) {
      print("Error fetching employees: $e");
    }
  }

  Future<void> _getUserId() async {
    try {
      // Fetch the current user from Firebase
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Use the Firebase user ID
        userId.value = user.uid;
      } else {
        // Try to retrieve the user ID from SharedPreferences if not signed in with Firebase
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? savedUserId = prefs.getString('userDocId');

        if (savedUserId != null && savedUserId.isNotEmpty) {
          userId.value = savedUserId;
        } else {
          // You can handle missing userId here (e.g., prompt login)
        }
      }

      // Save the user ID to SharedPreferences for future use
      if (userId.value.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userDocId', userId.value);
      }
    } catch (e) {
      print("Error fetching user ID: $e");
    }
  }

  // Image picking methods
  // Future<void> pickImageFromGallery() async {
  //   final XFile? pickedFile =
  //       await _picker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     profileImage.value = File(pickedFile.path);
  //   }
  // }

  // Future<void> pickImageFromCamera() async {
  //   final XFile? pickedFile =
  //       await _picker.pickImage(source: ImageSource.camera);
  //   if (pickedFile != null) {
  //     profileImage.value = File(pickedFile.path);
  //   }
  // }

  // Fetch methods
  Future<void> fetchServicesByCategory(String category) async {
    try {
      isLoading.value = true;
      var snapshot = await FirebaseFirestore.instance
          .collection('services_table')
          .where('category', isEqualTo: category)
          .get();
      services.value = snapshot.docs
          .map((doc) => ServiceModel.fromJson(doc.data()))
          .toList();
      if (services.isEmpty) {
        print("No services found for category: $category");
      }
    } catch (e) {
      print("Error fetching services by category: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getUserAddresses() async {
    addresses.clear();
    try {
      isLoading.value = true;

      if (userId.value.isEmpty) {
        print('User ID is not available');
        return;
      }

      final snapshot = await FirebaseFirestore.instance
          .collection('users_table')
          .where('user_id', isEqualTo: userId.value) // Using userId
          .get();

      if (snapshot.docs.isNotEmpty) {
        var userData = snapshot.docs.first.data();
        if (userData.containsKey('address')) {
          var addressList = userData['address'] as List<dynamic>;
          userAddresses.value = addressList
              .map((item) =>
                  AddressModel.fromFirestore(item as Map<String, dynamic>))
              .toList();

          print('Fetched ${addresses.length} addresses for user');
          print(addresses.value.first);
          isLoading.value = false;
        } else {
          print('No addresses found for this user');
        }
      } else {
        print('No user found with the stored user ID');
      }
    } catch (e) {
      print('Error fetching user addresses: $e');
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
      final userId =
          prefs.getString('userDocId'); // Changed to getString and 'userDocId'

      if (userId == null) {
        print('User ID not found in SharedPreferences');
        return;
      }

      var snapshot = await FirebaseFirestore.instance
          .collection('users_table') // Changed to users_table
          .doc(userId)
          .get();

      if (snapshot.exists && snapshot.data()!.containsKey('address')) {
        var addressData = snapshot.data()!['address'] as List<dynamic>;
        addresses.value = addressData
            .map((data) =>
                AddressModel.fromFirestore(data as Map<String, dynamic>))
            .toList();
        print('Fetched ${addresses.length} addresses for user');
      } else {
        print('No addresses found for this user');
      }
    } catch (e) {
      print("Error fetching addresses: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchBookings() async {
    try {
      if (userId.value.isEmpty) {
        print('User ID not found');
        return;
      }

      var snapshot = await FirebaseFirestore.instance
          .collection('size_based_bookings')
          .where('user_id', isEqualTo: userId.value) // Use userId here
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

// Review Related Methods..
  Future<Map<String, String>> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDetails = prefs.getString('userDetails');

    if (userDetails != null) {
      Map<String, dynamic> userMap = jsonDecode(userDetails);
      UserModel user = UserModel.fromFirestore(userMap);

      // Return user details like name, profile, email, etc.
      return {
        'userName': user.name ?? '',
        'userProfile': user.image ?? '',
        'userId': user.userId ?? '',
        'userEmail': user.email ?? '',
      };
    } else {
      // Handle no user case, maybe navigate to login
      return {};
    }
  }

  Future<void> addReviewToFirestore(ReviewModel review) async {
    try {
      CollectionReference reviews =
          FirebaseFirestore.instance.collection('review_table');

      // Save review to Firestore and retrieve document ID
      DocumentReference docRef = await reviews.add(review.toMap());

      // Update reviewId with the Firestore-generated document ID
      await docRef.update({'review_id': docRef.id});

      Get.snackbar('Success', 'Review added successfully',
          backgroundColor: Colors.green);
    } catch (e) {
      print('Error adding review: $e');
      Get.snackbar('Error', 'Failed to add review',
          backgroundColor: Colors.red);
    }
  }

  // Method to fetch reviews by category name
  Future<void> fetchReviewsByCategory(String categoryName) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('review_table')
          .where('category_name', isEqualTo: categoryName)
          .get();

      List<Review> fetchedReviews = querySnapshot.docs.map((doc) {
        return Review(
          userName: doc['user_name'],
          userImage: doc['user_profile'],
          rating: doc['rating'],
          comment: doc['review_message'],
        );
      }).toList();

      // Update the observable list
      reviews.assignAll(fetchedReviews);
      print('no of review : ${reviews.length}');
      print('no of review : ${fetchedReviews.length}');
    } catch (e) {
      print('Error fetching reviews: $e');
      reviews.clear(); // Clear the list on error
    }
  }

  // Cart-related methods
  Future<void> addToCart() async {
    if (selectedCategory.value == null) {
      Get.snackbar('Error', 'Please select a category',
          backgroundColor: Colors.red);
      return;
    }

    // Validate shifts
    if (selectedShifts.isEmpty) {
      Get.snackbar('Error', 'Please select at least one shift',
          backgroundColor: Colors.red);
      return;
    }

    final bookingData = await createBookingDocument(
      categoryName: selectedCategory.value!.categoryName,
      categoryImage: selectedCategory.value!.categoryImage,
      shifts: selectedShifts.toList(), // Pass selected shifts
    );
    print("selectedShifts.value ${selectedShifts.value}");
    final booking = BookingModel.fromFirestore(bookingData);
    cartBookings.add(booking);
    await saveCartToPrefs();
    clearSelections();
    Get.offAll(() => UserMain());
    Get.snackbar('Success', 'Added to cart', backgroundColor: Colors.green);
  }

  Future<void> saveCartToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartDataList =
          cartBookings.map((booking) => booking.toJson()).toList();
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
    final bookingData = await createBookingDocument(
      products: [product],
      categoryName: '',
      categoryImage: '',
    );
    final booking = BookingModel.fromFirestore(bookingData);
    cartBookings.add(booking);
    await saveCartToPrefs();
    Get.snackbar('Success', '${product.name} added to cart',
        backgroundColor: Colors.green);
  }

  // Booking processing methods
  // Updated method to process cart bookings
  Future<void> processCartBookings() async {
    try {
      Map<String, List<BookingModel>> bookingsByDateAndAddress = {};
      for (var booking in cartBookings) {
        DateTime bookingDate = DateTime.parse(booking.bookingDate).toLocal();
        DateTime dateOnly =
            DateTime(bookingDate.year, bookingDate.month, bookingDate.day);
        String addressKey =
            '${booking.location}_${booking.building}_${booking.floor}';
        String key = '${dateOnly.toIso8601String()}_$addressKey';

        if (!bookingsByDateAndAddress.containsKey(key)) {
          bookingsByDateAndAddress[key] = [];
        }
        bookingsByDateAndAddress[key]!.add(booking);
      }

      for (var entry in bookingsByDateAndAddress.entries) {
        if (entry.value.length > 1) {
          await _processCombinedBookings(entry.value);
        } else {
          await saveBookingToFirestore(
            bookingData: await createBookingDocument(
              bookingDate: DateTime.parse(entry.value.first.bookingDate),
              services: entry.value.first.services
                  .map((s) => ServiceSummaryModel(
                        serviceName: s.service_name,
                        totalQuantity: s.quantity,
                        totalSize: s.size,
                        totalPrice: s.price,
                      ))
                  .toList(),
              products: entry.value.first.products
                  .map((p) => UserProductModel(
                        name: p.product_name,
                        quantity: p.quantity,
                        deliveryTime: p.delivery_time,
                        price: p.price * p.quantity,
                        imageUrl: p.imageUrl,
                      ))
                  .toList(),
              categoryName: entry.value.first.categoryName,
              categoryImage: entry.value.first.categoryImage,
              address: AddressModel(
                building: entry.value.first.building,
                floor: entry.value.first.floor,
                geolocation: entry.value.first.geolocation,
                landmark: entry.value.first.landmark,
                location: entry.value.first.location,
              ),
              shifts:
                  entry.value.first.shift_names, // Add shifts from the booking
            ),
          );
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
    String categoryName = '';
    String categoryNameArabic = '';
    String categoryImage = '';
    AddressModel? address;
    Set<String> employeeIds = {}; // Using Set to avoid duplicates
    Set<String> shiftNames = {}; // Using Set to avoid duplicates
    DateTime bookingDate = DateTime.parse(bookings.first.bookingDate).toLocal();
    DateTime dateOnly =
        DateTime(bookingDate.year, bookingDate.month, bookingDate.day);

    for (var booking in bookings) {
      // Combine services
      for (var service in booking.services) {
        combinedServices.add(ServiceSummaryModel(
          serviceName: service.service_name,
          totalQuantity: service.quantity,
          totalSize: service.size,
          totalPrice: service.price,
        ));
      }

      // Combine products
      for (var product in booking.products) {
        combinedProducts.add(UserProductModel(
          name: product.product_name,
          quantity: product.quantity,
          deliveryTime: product.delivery_time,
          price: product.price,
          imageUrl: product.imageUrl,
        ));
      }

      // Take first non-empty category details
      if (categoryName.isEmpty && booking.categoryName.isNotEmpty) {
        categoryName = booking.categoryName;
        categoryNameArabic = booking.categoryNameArabic;
        categoryImage = booking.categoryImage;
      }

      // Take first address
      if (address == null) {
        address = AddressModel(
          building: booking.building,
          floor: booking.floor,
          geolocation: booking.geolocation,
          landmark: booking.landmark,
          location: booking.location,
        );
      }

      // Add employee IDs and shift names to sets
      employeeIds.addAll(booking.employee_ids);
      shiftNames.addAll(booking.shift_names);
    }

    // Create and save combined booking
    Map<String, dynamic> combinedBookingData = await createBookingDocument(
      bookingDate: dateOnly,
      services: combinedServices,
      products: combinedProducts,
      categoryName: categoryName,
      categoryImage: categoryImage,
      address: address,
      shifts: shiftNames.toList(),
    );

    // Add the combined employee IDs and shift names
    combinedBookingData['employee_ids'] = employeeIds.toList();
    combinedBookingData['shift_names'] = shiftNames.toList();
    combinedBookingData['category_name_arabic'] = categoryNameArabic;

    await saveBookingToFirestore(bookingData: combinedBookingData);
  }
  // ... existing code ...

  Future<void> updateProductQuantity(
      BookingModel booking, bool increment) async {
    int index = cartBookings.indexOf(booking);
    if (index != -1 && booking.products.isNotEmpty) {
      var product = booking.products.first;

      // Update quantity
      int newQuantity = increment ? product.quantity + 1 : product.quantity - 1;
      if (newQuantity < 1) newQuantity = 1;

      // Create updated product booking
      var updatedProduct = ProductBooking(
        product_name: product.product_name,
        product_name_arabic: product.product_name_arabic, // Include Arabic name
        quantity: newQuantity,
        delivery_time: product.delivery_time,
        price: product.price,
        imageUrl: product.imageUrl,
      );

      // Create updated booking data
      var updatedBookingData = createBookingDocument(
        products: [
          UserProductModel(
            name: updatedProduct.product_name,
            quantity: updatedProduct.quantity,
            deliveryTime: updatedProduct.delivery_time,
            price: updatedProduct.price,
            imageUrl: updatedProduct.imageUrl,
          )
        ],
        categoryName: booking.categoryName,
        categoryImage: booking.categoryImage,
        bookingDate: DateTime.parse(booking.bookingDate),
      );

      // Update booking in cart
      cartBookings[index] = BookingModel.fromFirestore(updatedBookingData);
      await saveCartToPrefs();
      cartBookings.refresh();
    }
  }

  Future<void> saveBookingToFirestore(
      {Map<String, dynamic>? bookingData}) async {
    try {
      final data = bookingData ?? await createBookingDocument();
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('size_based_bookings')
          .add(data);

      // Update the booking_id with the Firestore document ID
      await docRef.update({'booking_id': docRef.id});

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
    String? categoryName,
    String? categoryImage,
    String? userPhoneNumber,
    List<String>? shifts,
  }) {
    final now = DateTime.now();

    // Handle products list
    final List<Map<String, dynamic>> productsList =
        (products ?? selectedProducts)
            .map((product) => {
                  'product_name': product.name,
                  'product_name_arabic': '',
                  'quantity': product.quantity ?? 1,
                  'delivery_time': product.deliveryTime ?? '1-2 Days',
                  'price': product.price,
                  'image_url': product.imageUrl ?? ''
                })
            .toList();

    // Handle services list
    final List<Map<String, dynamic>> servicesList =
        (services ?? selectedServices)
            .map((service) => {
                  'quantity': service.totalQuantity,
                  'service_name': service.serviceName,
                  'service_name_arabic': '',
                  'size': service.totalSize,
                  'price': service.totalPrice,
                })
            .toList();

    return {
      'address': address?.location ?? selectedAddress.value?.location ?? '',
      'booking_date': bookingDate?.toString() ??
          selectedDate.value?.toString() ??
          now.toString(),
      'booking_id': '',
      'booking_time': DateFormat('h:mm a').format(bookingDate ?? now),
      'employee_ids': [],
      'shift_names': shifts ?? selectedShifts.toList(),
      'end_image': [], // Changed to empty list
      'payment_status': 'unassigned',
      'products': productsList,
      'services': servicesList,
      'start_image': [], // Changed to empty list
      'status': 'unassigned',
      'total_price':
          calculateTotalPrice(services: services, products: products),
      'user_id': userId.value,
      'user_phn_number': userPhoneNumber ?? '9999999999',
      'category_name':
          categoryName ?? selectedCategory.value?.categoryName ?? '',
      'category_name_arabic': '',
      'category_image':
          categoryImage ?? selectedCategory.value?.categoryImage ?? '',
      'building': address?.building ?? selectedAddress.value?.building ?? '',
      'floor': address?.floor ?? selectedAddress.value?.floor ?? 0,
      'Geolocation': [
        address?.geolocation.lat ??
            selectedAddress.value?.geolocation.lat ??
            '',
        address?.geolocation.lon ?? selectedAddress.value?.geolocation.lon ?? ''
      ],
      'landmark': address?.landmark ?? selectedAddress.value?.landmark ?? '',
      'location': address?.location ?? selectedAddress.value?.location ?? '',
      'time_taken': '', // New field initialized as empty
      'traveling_time': '', // New field initialized as empty
    };
  }
// Add this function to your UserProvider class

  Map<String, dynamic> createCallBookingDocument({
    required DateTime bookingDate,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required AddressModel address,
    required String categoryName,
    required String categoryImage,
    required String userPhoneNumber,
    List<String>? shifts,
  }) {
    final now = DateTime.now();

    // Format the times as strings
    final startTimeStr =
        '${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')}';
    final endTimeStr =
        '${endTime.hour}:${endTime.minute.toString().padLeft(2, '0')}';

    return {
      'address': address.location ?? '',
      'booking_date': bookingDate.toString(),
      'booking_id': '',
      'start_time': startTimeStr,
      'end_time': endTimeStr,
      'employee_ids': [],
      'shift_names': shifts ?? [],
      'end_image': [],
      'payment_status': 'unassigned',
      'start_image': [],
      'status': 'unassigned',
      'total_price': 0.0, // Initial price, can be updated later
      'user_id': userId.value,
      'user_phn_number': userPhoneNumber,
      'category_name': categoryName,
      'category_name_arabic': '',
      'category_image': categoryImage,
      'building': address.building ?? '',
      'floor': address.floor ?? 0,
      'Geolocation': [
        address.geolocation.lat ?? '',
        address.geolocation.lon ?? ''
      ],
      'landmark': address.landmark ?? '',
      'location': address.location ?? '',
      'time_taken': '',
      'traveling_time': '',
    };
  }

// Update the addCallBooking function to use createCallBookingDocument
  Future<void> addCallBooking({
    required String address,
    required DateTime bookingDate,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required CategoryModel category,
    required AddressModel addressModel,
    required String userPhoneNumber,
  }) async {
    try {
      final bookingsRef =
          FirebaseFirestore.instance.collection('call_based_bookings');
      final docRef = bookingsRef.doc();

      final bookingData = createCallBookingDocument(
        bookingDate: bookingDate,
        startTime: startTime,
        endTime: endTime,
        address: addressModel,
        categoryName: category.categoryName,
        categoryImage: category.categoryImage,
        userPhoneNumber: userPhoneNumber,
      );

      // Add the booking ID to the document
      bookingData['booking_id'] = docRef.id;

      // Add the document to Firestore using the generated ID
      await bookingsRef.doc(docRef.id).set(bookingData);
    } catch (e) {
      print('Error adding call booking: $e');
      rethrow;
    }
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
    selectedShifts.clear();
    availableShifts.clear();
  }

  double calculateTotalCartPrice() {
    return cartBookings.fold(0.0, (sum, booking) => sum + booking.total_price);
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
      print("  Category Name: ${booking.categoryName}");
      print("  Category Image: ${booking.categoryImage}");
      print("----------------------------------------");
    }
  }

  Future<List<AddressModel>?> getAddressFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDetails = prefs.getString('userDetails');

    if (userDetails != null) {
      // Convert the string back to Map and then to UserModel
      Map<String, dynamic> userMap = jsonDecode(userDetails);
      try {
        UserModel user = UserModel.fromFirestore(userMap);
        // Return the list of addresses
        return user.address;
      } catch (e) {
        print('Error decoding UserModel: $e');
        return null;
      }
    } else {
      print('No user details found in SharedPreferences');
    }

    return null;
  }
}
