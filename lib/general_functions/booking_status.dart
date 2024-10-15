import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BookingController extends GetxController {
  Future<void> updateBookingStatus(String bookingId, String status) async {
    try {
      List<String> validStatuses = [
        'unassigned',
        'assigned',
        'pending',
        'in-progress',
        'working',
        'completed',
        'cancelled'
      ];

      if (!validStatuses.contains(status)) {
        Get.snackbar('Error', 'Invalid status provided.');
        return;
      }

      DocumentReference bookingRef = FirebaseFirestore.instance
          .collection('size_based_bookings') // Your collection
          .doc(bookingId);

      await bookingRef.update({'status': status});

      Get.snackbar('Success', 'Booking status updated to $status.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update status: $e');
      print('Error updating booking status: $e');
    }
  }
}
