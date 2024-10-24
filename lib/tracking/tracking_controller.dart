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
  RxBool hasReachedDestination = false.obs;
  RxBool isLoading = false.obs; // Loading state
  StreamSubscription<Position>? positionStream;
  RxBool isLoadingETA = true.obs;
  RxBool isLoadingRemainingDistance = true.obs;
  final String googleAPIKey = 'AIzaSyAVoVAhzDDnrAY8pT_9v57TN0A0q9B4JGs';
  late DateTime startTime;
  LatLng previousLatLng = LatLng(0, 0);

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    // Set client location
    checkLocationPermission();
  }

  // void setClientLocation(double lat, double lon) {
  //   // Create a LatLng object with the provided latitude and longitude
  //   LatLng newLocation = LatLng(lat, lon);

  //   // Update the clientLocation variable
  //   clientLocation.value = newLocation;
  //   print("Client location set to: $lat, $lon");
  // }
  void setClientLocation(LatLng newLocation) {
    clientLocation.value = newLocation;
    print(
        "Client location set to: ${newLocation.latitude}, ${newLocation.longitude}");

    // Call functions after the client location is set
    startTracking(); // Start tracking when the location is set
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
      //  startTracking();
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
      saveEmployeeLocationToFirestore(position);
      checkIfReachedDestination();
    });
  }

  void checkIfReachedDestination() {
    if (remainingDistance.value <= 10000) {
      hasReachedDestination.value = true;
    }
  }

  void calculateDistance() {
    if (currentPosition.value != null && clientLocation.value != null) {
      isLoadingRemainingDistance.value = true;
      double distanceInMeters = Geolocator.distanceBetween(
        currentPosition.value!.latitude,
        currentPosition.value!.longitude,
        clientLocation.value!.latitude,
        clientLocation.value!.longitude,
      );
      remainingDistance.value = distanceInMeters;
      totalDistance.value = distanceInMeters / 1000;
      isLoadingRemainingDistance.value = false;
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
    isLoadingETA.value = true;
    Duration duration = DateTime.now().difference(startTime);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    elapsedTime.value = "$twoDigitMinutes:$twoDigitSeconds";
    isLoadingETA.value = false;
  }

  void moveMapToCurrentPosition() {
    if (mapController != null && currentPosition.value != null) {
      LatLng currentLatLng = LatLng(
        currentPosition.value!.latitude,
        currentPosition.value!.longitude,
      );

      // Check if the movement is significant (e.g., greater than 10 meters)
      if (Geolocator.distanceBetween(
              previousLatLng.latitude,
              previousLatLng.longitude,
              currentLatLng.latitude,
              currentLatLng.longitude) >
          10) {
        mapController!.animateCamera(CameraUpdate.newLatLng(currentLatLng));
        previousLatLng = currentLatLng; // Update the previous position
      }
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
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          rotation:
              currentPosition.value!.heading, // Use the heading for direction
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
    isLoading.value = true; // Show loading
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${employeeOrigin.latitude},${employeeOrigin.longitude}&destination=${clientDestination.latitude},${clientDestination.longitude}&key=$googleAPIKey';
    try {
      print('Fetching route with URL: $url'); // Debugging statement
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
          print("Route fetched successfully"); // Debugging statement
        } else {
          print('No routes found');
        }
      } else {
        print('Error fetching route: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false; // Hide loading
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

  Future<void> saveElapsedTime(String bookingId) async {
    try {
      await firestore.collection('size_based_bookings').doc(bookingId).update({
        'time_taken': elapsedTime.value,
        'timestamp': FieldValue
            .serverTimestamp(), // Optional: To track when it was saved
      });
      print("Elapsed time saved successfully: ${elapsedTime.value}");
    } catch (e) {
      print("Failed to save elapsed time: $e");
    }
  }

  @override
  void onClose() {
    positionStream?.cancel(); // Cancel position stream on close
    super.onClose();
  }
}
