import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:house_cleaning/employee/screens/employee_upload_after_images.dart';
import 'package:house_cleaning/user/models/bookings_model.dart';
import 'package:image_picker/image_picker.dart';
import '../screens/employee_review_photo.dart';

class CameraController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  var selectedImage = ''.obs; // Store selected image path
  var startImageUrls = <String>[].obs; // Changed to List<String>
  var endImageUrls = <String>[].obs; // Changed to List<String>
  var isStartImage = true.obs;
  // Track whether it's start or end image

  // Function to take or retake a photo
  Future<void> takestartPhoto(BookingModel booking) async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      selectedImage.value = photo.path;
      Get.to(() => ReviewPhotoPage(booking: booking));
    }
  }

  Future<void> takeafterPhoto(BookingModel booking) async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      selectedImage.value = photo.path;
      Get.to(() => UploadAfterImages(booking: booking));
    }
  }

  // void retakePhoto(BookingModel booking) {
  //   takestartPhoto(booking);
  // }

  Future<void> uploadPhotoWithStatus(String bookingId, String status) async {
    try {
      final File file = File(selectedImage.value);

      if (!file.existsSync()) {
        Get.snackbar('Error', 'No image selected or file does not exist.');
        return;
      }

      String fileName = file.path.split('/').last;
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('booking_images/$bookingId/$fileName');

      UploadTask uploadTask = storageRef.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;

      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      if (status == 'start') {
        startImageUrls.add(downloadUrl); // Add to list
        await FirebaseFirestore.instance
            .collection('size_based_bookings')
            .doc(bookingId)
            .update({'start_image': startImageUrls}); // Update with array
      } else if (status == 'end') {
        endImageUrls.add(downloadUrl); // Add to list
        await FirebaseFirestore.instance
            .collection('size_based_bookings')
            .doc(bookingId)
            .update({'end_image': endImageUrls}); // Update with array
      }

      Get.snackbar('Success', 'Photo uploaded successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload photo: $e');
      print("Error uploading photo: $e");
    }
  }
}
