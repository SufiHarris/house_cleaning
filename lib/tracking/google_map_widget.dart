import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'tracking_controller.dart';

class TrackingMap extends StatelessWidget {
  final TrackingController trackingController = Get.put(TrackingController());

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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                  'Remaining Distance: ${trackingController.remainingDistance.value.toStringAsFixed(2)} km',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Elapsed Time: ${trackingController.elapsedTime.value}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          )),
    );
  }
}
