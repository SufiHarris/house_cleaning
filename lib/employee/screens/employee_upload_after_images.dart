import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:house_cleaning/user/models/bookings_model.dart';

import '../../general_functions/booking_status.dart';
import '../../generated/l10n.dart';
import '../../theme/custom_colors.dart';
import '../controllers/camera_controller.dart';
import 'employee_order_overview.dart';

class UploadAfterImages extends StatelessWidget {
  final BookingModel booking;
  final BookingController bookingController = Get.put(BookingController());
  final CameraController controller = Get.put(CameraController());
  UploadAfterImages({super.key, required this.booking});

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
                : Text(S.of(context).noImageSelected,
                    style: TextStyle(fontSize: 16))),
            Spacer(),
            // ElevatedButton(
            //   onPressed: () {
            //     controller.retakePhoto(booking);
            //   },
            //   child: Text(S.of(context).retake),
            //   style: ElevatedButton.styleFrom(
            //     foregroundColor: CustomColors.textColorThree,
            //     backgroundColor: Colors.white,
            //     side: BorderSide(color: CustomColors.textColorThree),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(30.0),
            //     ),
            //     padding: EdgeInsets.symmetric(vertical: 16, horizontal: 70),
            //   ),
            // ),
            SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () async {
                await controller.takeafterPhoto(booking);
                try {
                  String bookingId =
                      booking.booking_id.toString(); // Use actual booking ID
                  await controller.uploadPhotoWithStatus(bookingId, 'end');
                  Get.snackbar(S.of(context).success, "PhotoAddedSuccessfully");
                  // S.of(context).photoAddedSuccessfully);
                } catch (e) {
                  Get.snackbar(S.of(context).error,
                      '${S.of(context).failedToUploadPhoto}: $e');
                }
              },
              child: Text(
                // S.of(context).addMorePhotos,
                "upload After Photos",
                //// Add a string for "Add More Photos"
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
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                Get.offAll(() => OrderOverviewPage());
              },
              child: Text(
                // S.of(context).uploadAndComplete,
                S.of(context).serviceCompleted,
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
