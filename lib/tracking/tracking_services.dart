import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:house_cleaning/tracking/tracking_controller.dart';

import 'directions_repository.dart';

class TrackingController extends GetxController {
  Rx<Position?> currentPosition = Rx<Position?>(null);
  RxList<LatLng> polylineCoordinates = <LatLng>[].obs;
  GoogleMapController? mapController;
  RxString eta = ''.obs;

  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition.value = position;
  }

  void updatePolyline(List<LatLng> points) {
    polylineCoordinates.assignAll(points);
  }

  Future<void> fetchRoute(LatLng origin, LatLng destination) async {
    final directions =
        await DirectionsRepository().getDirections(origin, destination);
    final points = PolylinePoints()
        .decodePolyline(directions['overview_polyline']['points']);
    final polyline =
        points.map((p) => LatLng(p.latitude, p.longitude)).toList();
    updatePolyline(polyline);

    eta.value = directions['duration']['text']; // Update ETA
  }
}
