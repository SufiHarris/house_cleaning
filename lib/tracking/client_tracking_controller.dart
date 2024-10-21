import 'dart:convert';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class ClientTrackingController extends GetxController {
  Rx<LatLng?> employeePosition = Rx<LatLng?>(null);
  Rx<LatLng> clientLocation = LatLng(34.1289468, 74.8416077).obs;
  RxString eta = ''.obs;
  RxList<LatLng> polylineCoordinates = <LatLng>[].obs;
  GoogleMapController? mapController;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String googleAPIKey = 'AIzaSyAVoVAhzDDnrAY8pT_9v57TN0A0q9B4JGs';

  RxInt remainingTimeInSeconds = 0.obs;
  final double employeeSpeed = 1.5;
  @override
  void onInit() {
    super.onInit();
    listenToEmployeeLocation();
  }

  void listenToEmployeeLocation() {
    firestore
        .collection('employee_locations')
        .doc('ya6nkjEN9IoMmAoL4DJx')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data();
        if (data != null) {
          GeoPoint geoPoint = data['geolocations'];
          employeePosition.value =
              LatLng(geoPoint.latitude, geoPoint.longitude);

          if (employeePosition.value != null) {
            fetchRouteForClient(employeePosition.value!, clientLocation.value);
          }
        }
      } else {
        print('No employee location data found');
      }
    });
  }

  Future<void> fetchRouteForClient(
      LatLng employeeDestination, LatLng clientOrigin) async {
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${clientOrigin.latitude},${clientOrigin.longitude}&destination=${employeeDestination.latitude},${employeeDestination.longitude}&key=$googleAPIKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['routes'].isNotEmpty) {
          final route = data['routes'][0]['overview_polyline']['points'];
          polylineCoordinates.clear();
          polylineCoordinates.addAll(_decodePolyline(route));

          final legs = data['routes'][0]['legs'][0];
          final distance = legs['distance']['value'];
          eta.value = legs['duration']['text'];

          calculateRemainingTime(distance);

          updateMapToFitRoute();
        } else {
          print('No routes found');
        }
      } else {
        print('Error fetching route: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching route: $e');
    }
  }

  void calculateRemainingTime(int distance) {
    remainingTimeInSeconds.value = (distance / employeeSpeed).round();
    startRemainingTimeTimer();
  }

  void startRemainingTimeTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTimeInSeconds.value > 0) {
        remainingTimeInSeconds.value--;
      } else {
        timer.cancel();
      }
    });
  }

  String formatRemainingTime(int totalSeconds) {
    final hours = (totalSeconds ~/ 3600);
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  List<LatLng> _decodePolyline(String polyline) {
    List<LatLng> decodedCoordinates = [];
    int index = 0, len = polyline.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;

      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      decodedCoordinates.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return decodedCoordinates;
  }

  void updateMapToFitRoute() {
    if (mapController != null) {
      LatLngBounds bounds = _boundsFromLatLngList(
          [clientLocation.value, employeePosition.value!]);
      mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
    }
  }

  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    double x0, x1, y0, y1;
    x0 = x1 = list[0].latitude;
    y0 = y1 = list[0].longitude;

    for (LatLng latLng in list) {
      if (latLng.latitude > x1) x1 = latLng.latitude;
      if (latLng.latitude < x0) x0 = latLng.latitude;
      if (latLng.longitude > y1) y1 = latLng.longitude;
      if (latLng.longitude < y0) y0 = latLng.longitude;
    }
    return LatLngBounds(
      northeast: LatLng(x1, y1),
      southwest: LatLng(x0, y0),
    );
  }
}
