// models/employee_model.dart
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Employee {
  final String id;
  final String name;
  final LatLng geolocations; // Using LatLng from google_maps_flutter
  final Duration totalTimeTaken;

  Employee({
    required this.id,
    required this.name,
    required this.geolocations,
    required this.totalTimeTaken,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'],
      geolocations: LatLng(
          json['geolocations']['latitude'], json['geolocations']['longitude']),
      totalTimeTaken: Duration(seconds: json['totalTimeTaken']),
    );
  }
}
