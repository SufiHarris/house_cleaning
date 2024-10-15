import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../user/models/bookings_model.dart';

class AdminProvider extends GetxController {
  var bookings = <BookingModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
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
}
