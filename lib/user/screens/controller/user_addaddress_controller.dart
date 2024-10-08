import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddAddressController extends GetxController {
  var locationController = TextEditingController();
  var buildingController = TextEditingController();
  var floorController = TextEditingController();
  var landmarkController = TextEditingController();
  Rx<LatLng?> currentLocation = Rx<LatLng?>(null);

  Future<void> setLocationFromMap(LatLng selectedLocation) async {
    try {
      currentLocation.value = selectedLocation;

      List<Placemark> placemarks = await placemarkFromCoordinates(
          selectedLocation.latitude, selectedLocation.longitude);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        locationController.text =
            '${placemark.name}, ${placemark.locality}, ${placemark.country}';
      } else {
        locationController.text = 'Selected Location';
      }
    } catch (e) {
      print('Error setting location from map: $e');
      Get.snackbar("Error", "Failed to set the location from map.");
    }
  }

  Future<void> useCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar(
            "Error", "Location services are disabled. Please enable them.");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar("Error", "Location permission denied.");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          "Error",
          "Location permission permanently denied. Enable it from settings.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
        ),
      );

      currentLocation.value = LatLng(position.latitude, position.longitude);

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        locationController.text =
            '${placemark.name}, ${placemark.locality}, ${placemark.country}';
      } else {
        locationController.text = 'Current Location';
      }
    } catch (e) {
      print('Error getting location: $e');
      Get.snackbar("Error", "Failed to get the current location.");
    }
  }

  Future<void> saveAddress() async {
    if (currentLocation.value == null) {
      Get.snackbar(
        "Error",
        "Please provide a location or use the current location.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    // Check user authentication
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Get.snackbar(
        "Error",
        "User not authenticated. Please log in.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    String userEmail = user.email ?? '';
    print("User Email: $userEmail");

    try {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users_table')
          .where('email', isEqualTo: userEmail)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        String docId = userSnapshot.docs.first.id;
        print("User Document ID: $docId");

        DocumentReference addressRef = await FirebaseFirestore.instance
            .collection('users_table')
            .doc('SmmKMTVkMvHGEa0BB92I')
            .collection('addresses')
            .add({
          'location': locationController.text,
          'building': buildingController.text,
          'floor': floorController.text,
          'landmark': landmarkController.text,
          'geolocation': GeoPoint(
            currentLocation.value!.latitude,
            currentLocation.value!.longitude,
          ),
          'timestamp': FieldValue.serverTimestamp(),
        });

        print("Address saved successfully: ${addressRef.id}");
        Get.snackbar(
          "Success",
          "Address saved successfully.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.greenAccent,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          "User document not found in Firestore.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error saving address: $e'); // Log error
      Get.snackbar(
        "Error",
        "Failed to save address: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }
}
