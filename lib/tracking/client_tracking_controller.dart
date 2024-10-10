import 'dart:convert';
import 'dart:async'; // Import Timer
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart'; // Add this import

class ClientTrackingController extends GetxController {
  Rx<LatLng?> employeePosition = Rx<LatLng?>(null); // Employee position
  Rx<LatLng> clientLocation =
      LatLng(34.1289468, 74.8416077).obs; // Client's location
  RxString eta = ''.obs; // To hold ETA value
  RxList<LatLng> polylineCoordinates =
      <LatLng>[].obs; // Polyline points for route
  GoogleMapController? mapController; // Map controller

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String googleAPIKey =
      'AIzaSyAVoVAhzDDnrAY8pT_9v57TN0A0q9B4JGs'; // Replace with your Google API key

  RxInt remainingTimeInSeconds = 0.obs; // Remaining time in seconds
  final double employeeSpeed =
      1.5; // Example: Speed in m/s (e.g., walking speed)

  @override
  void onInit() {
    super.onInit();
    listenToEmployeeLocation(); // Start listening to employee location updates
  }

  // Listen to the employee's location from Firestore
  void listenToEmployeeLocation() {
    firestore
        .collection('employee_locations')
        .doc('ya6nkjEN9IoMmAoL4DJx') // Replace with correct document ID
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data();
        if (data != null) {
          GeoPoint geoPoint =
              data['geolocations']; // Get GeoPoint from Firestore
          employeePosition.value = LatLng(geoPoint.latitude,
              geoPoint.longitude); // Convert GeoPoint to LatLng

          // Once employee location is loaded, fetch the route
          if (employeePosition.value != null) {
            fetchRouteForClient(employeePosition.value!,
                clientLocation.value); // Reverse origin and destination
          }
        }
      } else {
        print('No employee location data found');
      }
    });
  }

  // Fetch the route between employee and client using Google Directions API
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
          polylineCoordinates
              .addAll(_decodePolyline(route)); // Decode and set polyline

          // Get distance
          final legs = data['routes'][0]['legs'][0];
          final distance = legs['distance']['value']; // Distance in meters
          eta.value = legs['duration']['text']; // Set the ETA

          // Calculate remaining time based on distance and speed
          calculateRemainingTime(distance);

          // Once we have the route, adjust the camera to fit both points
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

  // Calculate remaining time based on distance and speed
  void calculateRemainingTime(int distance) {
    // Calculate time in seconds based on distance and speed
    remainingTimeInSeconds.value = (distance / employeeSpeed).round();
    startRemainingTimeTimer(); // Start the timer
  }

  // Start the timer for remaining time
  void startRemainingTimeTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTimeInSeconds.value > 0) {
        remainingTimeInSeconds.value--;
      } else {
        timer.cancel();
      }
    });
  }

  // Method to format remaining time to HR-MM-SS
  String formatRemainingTime(int totalSeconds) {
    final hours = (totalSeconds ~/ 3600);
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // Decode the encoded polyline from the Directions API into a list of LatLng points
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

  // Adjust the map to fit both the client and employee locations along with the polyline
  void updateMapToFitRoute() {
    if (mapController != null) {
      LatLngBounds bounds = _boundsFromLatLngList(
          [clientLocation.value, employeePosition.value!]);
      mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
    }
  }

  // Calculate LatLngBounds to fit the map view to both locations
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
