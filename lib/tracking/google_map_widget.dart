import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../employee/screens/employee_address_details.dart';
import '../general_functions/booking_status.dart';
import '../theme/custom_colors.dart';
import '../user/models/bookings_model.dart';
import 'tracking_controller.dart';
// import 'upload_complete_page.dart';

class EmployeeTrackingMap extends StatelessWidget {
  final BookingModel booking; // Required booking parameter
  // final String status; // Added status parameter

  EmployeeTrackingMap({Key? key, required this.booking}) : super(key: key);

  final BookingController bookingController = Get.put(BookingController());
  final EmployeeTrackingController trackingController =
      Get.put(EmployeeTrackingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Track Employee')),
      body: Obx(() {
        if (trackingController.currentPosition.value == null) {
          return Center(child: CircularProgressIndicator());
        }

        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(
              trackingController.currentPosition.value!.latitude,
              trackingController.currentPosition.value!.longitude,
            ),
            zoom: 18,
          ),
          polylines: {
            Polyline(
              polylineId: PolylineId('route'),
              points: trackingController.polylineCoordinates,
              color: Colors.blue,
              width: 6,
            ),
          },
          markers: trackingController.markers.toSet(),
          onMapCreated: (GoogleMapController controller) {
            trackingController.mapController = controller;
            trackingController.moveMapToCurrentPosition();
          },
        );
      }),
      bottomSheet: Obx(() => Container(
            color: Colors.white,
            padding: const EdgeInsets.all(8.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(
                'ETA: ${trackingController.eta.value}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Total Distance: ${trackingController.totalDistance.value.toStringAsFixed(2)} km',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Elapsed Time: ${trackingController.elapsedTime.value}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: trackingController.hasReachedDestination.value
                    ? () {
                        bookingController.updateBookingStatus(
                            booking.booking_id.toString(), 'working');

                        Get.to(() => ClientDetailsPage(
                              booking: booking,
                            ));
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      trackingController.hasReachedDestination.value
                          ? CustomColors.textColorThree
                          : Colors.grey,
                ),
                child: Text(
                  "Reached",
                  style: TextStyle(
                    color: trackingController.hasReachedDestination.value
                        ? Colors.white
                        : Color(0xFFBDBDBD),
                  ),
                ),
              ),
            ]),
          )),
    );
  }
}
