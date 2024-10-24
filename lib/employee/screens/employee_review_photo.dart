import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/employee/controllers/camera_controller.dart';
import 'package:house_cleaning/employee/screens/employee_order_overview.dart';
import '../../general_functions/booking_status.dart';
import '../../generated/l10n.dart';
import '../../theme/custom_colors.dart';
import '../../user/models/bookings_model.dart';
import 'employee_upload_after_images.dart';

class ReviewPhotoPage extends StatelessWidget {
  final BookingModel booking;
  final BookingController bookingController = Get.put(BookingController());
  final CameraController controller = Get.put(CameraController());

  ReviewPhotoPage({super.key, required this.booking});

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
                await controller.takestartPhoto(booking);
                try {
                  String bookingId =
                      booking.booking_id.toString(); // Use actual booking ID
                  await controller.uploadPhotoWithStatus(bookingId, 'start');
                  Get.snackbar(S.of(context).success, "PhotoAddedSuccessfully");
                  // S.of(context).photoAddedSuccessfully);
                } catch (e) {
                  Get.snackbar(S.of(context).error,
                      '${S.of(context).failedToUploadPhoto}: $e');
                }
              },
              child: Text(
                // S.of(context).addMorePhotos,
                "AddMore Photos",
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
                // await controller.takePhoto(booking);
                // try {
                //   String bookingId =
                //       booking.booking_id.toString(); // Use actual booking ID
                //   await controller.uploadPhotoWithStatus(bookingId, 'end');
                //   bookingController.updateBookingStatus(
                //       booking.booking_id.toString(), 'completed');

                //   Get.snackbar(
                //       S.of(context).success,
                //       S
                //           .of(context)
                //           .photoUploadedSuccessfully); // Localized success message
                Get.to(() => UploadAfterImages(booking: booking));
                // } catch (e) {
                //   Get.snackbar(S.of(context).error,
                //       '${S.of(context).failedToUploadPhoto}: $e'); // Localized error message
                // }
              },
              child: Text(
                "Next",
                // S.of(context).uploadAndComplete,
                // S.of(context).uploadAfterImages,
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
