import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../employee/screens/employee_address_details.dart';
import '../theme/custom_colors.dart';
import 'tracking_controller.dart';
// import 'upload_complete_page.dart';

class EmployeeTrackingMap extends StatelessWidget {
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
              // Text(
              //   'Remaining Distance: ${trackingController.remainingDistance.value.toStringAsFixed(2)} km',
              //   style: TextStyle(fontSize: 16),
              // ),
              SizedBox(height: 8),
              Text(
                'Elapsed Time: ${trackingController.elapsedTime.value}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                  onPressed: trackingController.hasReachedDestination.value
                      ? () {
                          // Navigate to upload screen when "Reached" is clicked
                          Get.to(() => ClientDetailsPage());
                        }
                      : null, // Disable until reached
                  style: ElevatedButton.styleFrom(
                    backgroundColor: trackingController
                            .hasReachedDestination.value
                        ? CustomColors.textColorThree // Normal enabled color
                        : Colors.grey, // Disabled color
                  ),
                  child: Text(
                    "Reached",
                    style: TextStyle(
                      color: trackingController.hasReachedDestination.value
                          ? Colors.white // Normal enabled text color
                          : Color(0xFFBDBDBD), // Disabled text color
                    ),
                  )),
            ]),
          )),
    );
  }
}
