import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateBookingStatus(String bookingId, String status) async {
    try {
      await _firestore
          .collection('size_based_bookings')
          .doc('0xm1mKrOmvKV2tJL5tUX')
          .update({
        'status': status,
      });
      print('Status updated to $status for booking ID $bookingId');
    } catch (e) {
      print('Error updating status: $e');
    }
  }
}
