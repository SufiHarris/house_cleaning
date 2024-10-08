import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionsRepository {
  final String apiKey = 'AIzaSyCzwP8ES6IY4TyjJ9O5aXHSjjS4ZXlPGxM';

  Future<Map<String, dynamic>> getDirections(
      LatLng origin, LatLng destination) async {
    final response = await http.get(
      Uri.parse(
          'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch directions');
    }
  }
}
