import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'client_tracking_controller.dart';

class ClientTrackingMap extends StatelessWidget {
  final ClientTrackingController trackingController =
      Get.put(ClientTrackingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Track Employee')),
      body: Obx(() {
        if (trackingController.employeePosition.value == null) {
          return Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: trackingController.clientLocation
                    .value, // Set initial camera to client location
                zoom: 16,
              ),
              markers: {
                Marker(
                  markerId: MarkerId('employee'),
                  position: trackingController.employeePosition.value!,
                  infoWindow: InfoWindow(title: 'Employee Location'),
                ),
                Marker(
                  markerId: MarkerId('client'),
                  position: trackingController.clientLocation.value,
                  infoWindow: InfoWindow(title: 'Your Location'),
                ),
              },
              polylines: {
                Polyline(
                  polylineId: PolylineId('route'),
                  points: trackingController.polylineCoordinates,
                  color: Colors.blue,
                  width: 6,
                ),
              },
              onMapCreated: (GoogleMapController controller) {
                trackingController.mapController = controller;
                trackingController
                    .updateMapToFitRoute(); // Adjust the camera once the map is created
              },
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    Text(
                      'ETA: ${trackingController.eta.value}', // Display the ETA
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Obx(() => Text(
                          '${trackingController.formatRemainingTime(trackingController.remainingTimeInSeconds.value)} remaining',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
