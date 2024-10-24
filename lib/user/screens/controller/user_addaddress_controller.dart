import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:house_cleaning/user/screens/user_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

      // Get current position with correct parameters
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 5),
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

    // Validate floor input
    if (floorController.text.isEmpty || !isNumeric(floorController.text)) {
      Get.snackbar(
        "Error",
        "Please enter a valid floor number",
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

    String userId = user.uid;
    print("User ID: $userId");

    try {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users_table').doc(userId);
      DocumentSnapshot userDocSnapshot = await userDocRef.get();

      if (userDocSnapshot.exists) {
        Map<String, dynamic>? userData =
            userDocSnapshot.data() as Map<String, dynamic>?;

        List<dynamic> existingAddresses = userData?['address'] ?? [];

        Map<String, dynamic> newAddress = {
          'Building': buildingController.text,
          'Floor': int.parse(floorController.text),
          'Geolocation': [
            currentLocation.value!.latitude,
            currentLocation.value!.longitude
          ],
          'Landmark': landmarkController.text,
          'Location': locationController.text,
        };

        existingAddresses.add(newAddress);
        await userDocRef.update({'address': existingAddresses});

        print("Address saved successfully: $newAddress");

        // Update SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userDetails = prefs.getString('userDetails');

        if (userDetails != null) {
          Map<String, dynamic> userMap = jsonDecode(userDetails);
          List<dynamic> localAddresses = userMap['address'] ?? [];
          localAddresses.add(newAddress);
          userMap['address'] = localAddresses;

          String updatedUserJson = jsonEncode(userMap);
          await prefs.setString('userDetails', updatedUserJson);

          print('Updated user details in SharedPreferences: $updatedUserJson');
          Get.to(() => UserSettings()); // Navigate using recommended approach
        }

        Get.snackbar(
          "Success",
          "Address saved successfully.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.greenAccent,
          colorText: Colors.white,
        );

        // Clear controllers after successful save
        clearControllers();
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
      print('Error saving address: $e');
      Get.snackbar(
        "Error",
        "Failed to save address: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  // Helper method to check if string is numeric
  bool isNumeric(String str) {
    if (str.isEmpty) return false;
    return int.tryParse(str) != null;
  }

  // Clear all controllers
  void clearControllers() {
    locationController.clear();
    buildingController.clear();
    floorController.clear();
    landmarkController.clear();
    currentLocation.value = null;
  }

  @override
  void onClose() {
    locationController.dispose();
    buildingController.dispose();
    floorController.dispose();
    landmarkController.dispose();
    super.onClose();
  }
}
