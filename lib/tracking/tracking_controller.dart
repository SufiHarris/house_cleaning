import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class EmployeeTrackingController extends GetxController {
  Rx<Position?> currentPosition = Rx<Position?>(null);
  Rx<LatLng?> clientLocation = Rx<LatLng?>(null);
  RxList<LatLng> polylineCoordinates = <LatLng>[].obs;
  GoogleMapController? mapController;
  RxString eta = ''.obs;
  RxDouble totalDistance = 0.0.obs;
  RxDouble remainingDistance = 0.0.obs;
  RxSet<Marker> markers = <Marker>{}.obs;
  RxString elapsedTime = ''.obs;
  StreamSubscription<Position>? positionStream;
  final String googleAPIKey =
      'AIzaSyAVoVAhzDDnrAY8pT_9v57TN0A0q9B4JGs'; // Replace with your API key
  late DateTime startTime;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    clientLocation.value =
        LatLng(34.1289468, 74.8416077); // Set client location
    checkLocationPermission();
  }

  void checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      showPermissionDialog();
      return;
    }
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      startTracking();
    } else {
      print('Location permission not granted.');
    }
  }

  void showPermissionDialog() {
    Get.defaultDialog(
      title: "Location Permission Required",
      middleText:
          "To use location features, please allow location access in your app settings.",
      confirm: ElevatedButton.icon(
        icon: Icon(Icons.settings),
        label: Text("Allow in Settings"),
        onPressed: () {
          Geolocator.openAppSettings();
          Get.back();
        },
      ),
      cancel: TextButton(
        child: Text("Not Now"),
        onPressed: () {
          Get.back();
        },
      ),
    );
  }

  void startTracking() {
    startTime = DateTime.now();
    elapsedTime.value = "0:00";
    positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1,
      ),
    ).listen((Position position) {
      currentPosition.value = position;
      updateMarkers();
      calculateDistance();
      moveMapToCurrentPosition();
      fetchRouteForEmployee(
          LatLng(position.latitude, position.longitude), clientLocation.value!);
      updateElapsedTime();
      adjustZoomBasedOnSpeed(position.speed);
      saveEmployeeLocationToFirestore(position);
    });
  }

  void calculateDistance() {
    if (currentPosition.value != null && clientLocation.value != null) {
      double distanceInMeters = Geolocator.distanceBetween(
        currentPosition.value!.latitude,
        currentPosition.value!.longitude,
        clientLocation.value!.latitude,
        clientLocation.value!.longitude,
      );
      remainingDistance.value = distanceInMeters;
      totalDistance.value = distanceInMeters / 1000;
    }
  }

  void saveEmployeeLocationToFirestore(Position position) async {
    try {
      await firestore
          .collection('employee_locations')
          .doc('ya6nkjEN9IoMmAoL4DJx')
          .set({
        'geolocations': GeoPoint(position.latitude, position.longitude),
        'timestamp': FieldValue.serverTimestamp(),
      });
      print("Location updated in Firestore.");
    } catch (e) {
      print("Failed to update location in Firestore: $e");
    }
  }

  void updateElapsedTime() {
    Duration duration = DateTime.now().difference(startTime);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    elapsedTime.value = "$twoDigitMinutes:$twoDigitSeconds";
  }

  void moveMapToCurrentPosition() {
    if (mapController != null && currentPosition.value != null) {
      LatLng currentLatLng = LatLng(
        currentPosition.value!.latitude,
        currentPosition.value!.longitude,
      );
      mapController!.animateCamera(
        CameraUpdate.newLatLng(currentLatLng),
      );
    }
  }

  void adjustZoomBasedOnSpeed(double speed) {
    if (mapController != null) {
      double zoomLevel;
      if (speed < 10) {
        zoomLevel = 18.0;
      } else if (speed < 15) {
        zoomLevel = 16.0;
      } else {
        zoomLevel = 14.0;
      }
      mapController!.animateCamera(CameraUpdate.zoomTo(zoomLevel));
    }
  }

  void updateMarkers() {
    markers.clear();
    if (currentPosition.value != null) {
      markers.add(
        Marker(
          markerId: MarkerId('employee'),
          position: LatLng(
            currentPosition.value!.latitude,
            currentPosition.value!.longitude,
          ),
        ),
      );
    }
    if (clientLocation.value != null) {
      markers.add(
        Marker(
          markerId: MarkerId('client'),
          position: clientLocation.value!,
        ),
      );
    }
  }

  Future<void> fetchRouteForEmployee(
      LatLng employeeOrigin, LatLng clientDestination) async {
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${employeeOrigin.latitude},${employeeOrigin.longitude}&destination=${clientDestination.latitude},${clientDestination.longitude}&key=$googleAPIKey';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['routes'].isNotEmpty) {
          final route = data['routes'][0]['overview_polyline']['points'];
          polylineCoordinates.clear();
          polylineCoordinates.addAll(_decodePolyline(route));
          final legs = data['routes'][0]['legs'][0];
          eta.value = legs['duration']['text'];
          totalDistance.value = legs['distance']['value'] / 1000;
          updateMarkers();
          updateMapToFitRoute();
        } else {
          print('No routes found');
        }
      } else {
        print('Error fetching route: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
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
      decodedCoordinates.add(LatLng((lat / 1E5), (lng / 1E5)));
    }
    return decodedCoordinates;
  }

  void updateMapToFitRoute() {
    if (mapController != null &&
        currentPosition.value != null &&
        clientLocation.value != null) {
      LatLng employeeLatLng = LatLng(
          currentPosition.value!.latitude, currentPosition.value!.longitude);
      LatLng clientLatLng = clientLocation.value!;

      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(
          employeeLatLng.latitude < clientLatLng.latitude
              ? employeeLatLng.latitude
              : clientLatLng.latitude,
          employeeLatLng.longitude < clientLatLng.longitude
              ? employeeLatLng.longitude
              : clientLatLng.longitude,
        ),
        northeast: LatLng(
          employeeLatLng.latitude > clientLatLng.latitude
              ? employeeLatLng.latitude
              : clientLatLng.latitude,
          employeeLatLng.longitude > clientLatLng.longitude
              ? employeeLatLng.longitude
              : clientLatLng.longitude,
        ),
      );

      mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
    }
  }

  @override
  void onClose() {
    positionStream?.cancel(); // Cancel position stream on close
    super.onClose();
  }
}
