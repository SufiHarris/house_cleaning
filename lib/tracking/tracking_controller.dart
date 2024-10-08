import 'dart:convert';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class TrackingController extends GetxController {
  Rx<Position?> currentPosition = Rx<Position?>(null);
  Rx<LatLng?> clientLocation = Rx<LatLng?>(null);
  RxList<LatLng> polylineCoordinates = <LatLng>[].obs;
  GoogleMapController? mapController;
  RxString eta = ''.obs;
  RxInt totalTime = 0.obs; // Total time taken in seconds

  @override
  void onInit() {
    super.onInit();

    // Set mock current position (employee location)
    currentPosition.value = Position(
      latitude: 40.7128, // New York City
      longitude: -74.0060,
      timestamp: DateTime.now(),
      accuracy: 1.0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
    );

    clientLocation.value = LatLng(41.8781, -87.6298); //chicago

    fetchRoute(
      currentPosition.value != null
          ? LatLng(
              currentPosition.value!.latitude, currentPosition.value!.longitude)
          : LatLng(37.7749, -122.4194),
      clientLocation.value!,
    );

    moveEmployee();
  }

  Future<void> fetchRoute(LatLng origin, LatLng destination) async {
    String googleApiKey = 'AIzaSyAVoVAhzDDnrAY8pT_9v57TN0A0q9B4JGs';

    final response = await http.get(
      Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$googleApiKey',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("API Response: $data"); // Log the full response

      if (data['routes'].isNotEmpty) {
        var legs = data['routes'][0]['legs'][0];
        totalTime.value = legs['duration']['value'];

        // Get polyline points
        polylineCoordinates.clear();
        var polyline = legs['steps'].map<LatLng>((step) {
          var startLocation = step['start_location'];
          return LatLng(startLocation['lat'], startLocation['lng']);
        }).toList();

        // Add intermediate points for smooth movement
        for (var step in legs['steps']) {
          var polylinePoints = step['polyline']['points'];
          polylineCoordinates.addAll(decodePolyline(polylinePoints));
        }

        eta.value = formatDuration(totalTime.value);
        update(); // Notify listeners
      } else {
        print('No routes found');
      }
    } else {
      print('Failed to load directions: ${response.statusCode}');
    }
  }

  void moveEmployee() async {
    if (polylineCoordinates.isNotEmpty) {
      for (LatLng point in polylineCoordinates) {
        currentPosition.value = Position(
          latitude: point.latitude,
          longitude: point.longitude,
          timestamp: DateTime.now(),
          accuracy: 1.0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );

        // Update map position
        await Future.delayed(
            Duration(seconds: 1)); // Simulate time taken to move
      }
    }
  }

  String formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    return '${duration.inHours} hours, ${duration.inMinutes.remainder(60)} minutes';
  }

  List<LatLng> decodePolyline(String polyline) {
    List<LatLng> points = [];
    var index = 0, len = polyline.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result >> 1) ^ (~(result << 1) >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result >> 1) ^ (~(result << 1) >> 1);
      lng += dlng;

      LatLng point = LatLng(lat / 1E5, lng / 1E5);
      points.add(point);
    }
    return points;
  }
}
