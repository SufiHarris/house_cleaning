import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/employee/controllers/employee_address_details_controller.dart';
import 'package:house_cleaning/employee/screens/employee_review_photo.dart';
import 'package:house_cleaning/theme/custom_colors.dart';

import '../controllers/camera_controller.dart';

class ClientDetailsPage extends StatelessWidget {
  final ClientDetailsController controller = Get.put(ClientDetailsController());
  final CameraController cameracontroller = Get.put(CameraController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: CustomColors.textColorThree),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text('Reached',
            style: TextStyle(color: CustomColors.textColorThree)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Client Address',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(controller.clientAddress.value,
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 16),
              Text(
                'Landmark',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(controller.landmark.value, style: TextStyle(fontSize: 16)),
              SizedBox(height: 16),
              Text(
                'Entry Instructions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(controller.entryInstructions.value,
                  style: TextStyle(fontSize: 16)),
              Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  // Implement call functionality here
                },
                icon: Icon(Icons.phone, color: CustomColors.textColorThree),
                label: Obx(() => Text(controller.contactNumber.value)),
                style: ElevatedButton.styleFrom(
                  foregroundColor: CustomColors.textColorThree,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(
                        color: CustomColors.textColorThree, width: 1),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 70, vertical: 16),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await cameracontroller.takePhoto();
                  try {
                    String bookingId = "0xm1mKrOmvKV2tJL5tUX";
                    await cameracontroller.uploadPhotoWithStatus(
                        bookingId, 'start');

                    Get.snackbar('Success', 'Photo uploaded successfully');
                    Get.to(() => ReviewPhotoPage());
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
                  padding: EdgeInsets.symmetric(horizontal: 70, vertical: 16),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
