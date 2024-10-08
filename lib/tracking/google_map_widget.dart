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
        // Ensure that the map only loads when all required data is available
        if (trackingController.currentPosition.value == null) {
          return Center(child: CircularProgressIndicator());
        }

        if (trackingController.polylineCoordinates.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(
              trackingController.currentPosition.value!.latitude,
              trackingController.currentPosition.value!.longitude,
            ),
            zoom: 14,
          ),
          polylines: {
            Polyline(
              polylineId: PolylineId('route'),
              points: trackingController.polylineCoordinates,
              color: Colors.blue,
              width: 6,
            ),
          },
          markers: {
            Marker(
              markerId: MarkerId('employee'),
              position: LatLng(
                trackingController.currentPosition.value!.latitude,
                trackingController.currentPosition.value!.longitude,
              ),
            ),
            if (trackingController.clientLocation.value != null)
              Marker(
                markerId: MarkerId('client'),
                position: trackingController.clientLocation.value!,
              ),
          },
          onMapCreated: (GoogleMapController controller) {
            trackingController.mapController = controller;
          },
        );
      }),
      bottomSheet: Obx(() => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('ETA: ${trackingController.eta.value}'),
          )),
    );
  }
}
