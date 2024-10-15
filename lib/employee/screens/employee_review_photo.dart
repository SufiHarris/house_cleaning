import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/employee/controllers/camera_controller.dart';
import 'package:house_cleaning/employee/screens/employee_order_overview.dart';
import '../../theme/custom_colors.dart';

class ReviewPhotoPage extends StatelessWidget {
  final CameraController controller = Get.put(CameraController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: CustomColors.textColorThree),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => controller.selectedImage.value != ''
                ? Image.file(
                    File(controller.selectedImage.value),
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  )
                : Text('No image selected', style: TextStyle(fontSize: 16))),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                controller.retakePhoto();
              },
              child: Text('Retake'),
              style: ElevatedButton.styleFrom(
                foregroundColor: CustomColors.textColorThree,
                backgroundColor: Colors.white,
                side: BorderSide(color: CustomColors.textColorThree),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 70),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await controller.takePhoto();
                try {
                  String bookingId = "0xm1mKrOmvKV2tJL5tUX";
                  await controller.uploadPhotoWithStatus(bookingId, 'end');

                  Get.snackbar('Success', 'Photo uploaded successfully');
                  Get.to(() => OrderOverviewPage());
                } catch (e) {
                  Get.snackbar('Error', 'Failed to upload photo: $e');
                }
              },
              child: Text(
                'Upload & Complete',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.textColorThree,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
