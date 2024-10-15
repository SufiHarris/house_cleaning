import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  final String name;
  final String email;
  final String image;
  final String password;
  final String phone; // Add phone field
  final String userId; // Add this line

  final List<AddressModel> address;

  UserModel({
    required this.name,
    required this.email,
    required this.image,
    required this.password,
    required this.address,
    required this.phone, // Include phone in the constructor
    required this.userId,
  });

  // Factory method to create a UserModel from Firestore data
  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    var addressList = data['address'] as List<dynamic>;
    List<AddressModel> addresses = addressList
        .map((item) => AddressModel.fromFirestore(item as Map<String, dynamic>))
        .toList();

    return UserModel(
      name: data['name'],
      email: data['email'],
      image: data['image'] ?? "",
      password: data['password'],
      address: addresses,
      phone: data['phone'] ?? "", // Get phone from Firestore data
      userId: data['user_id'] ?? "",
    );
  }

  // Convert to map for saving in SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'image': image,
      'password': password,
      'address': address.map((e) => e.toMap()).toList(),
      'phone': phone, // Include phone in the map
      'user_id': userId, // Add user_id to the map
    };
  }
}

class AddressModel {
  final String building;
  final int floor;
  final GeoLocationModel geolocation;
  final String landmark;
  final String location;

  AddressModel({
    required this.building,
    required this.floor,
    required this.geolocation,
    required this.landmark,
    required this.location,
  });

  factory AddressModel.fromFirestore(Map<String, dynamic> data) {
    var geolocationData = data['Geolocation']
        as List<dynamic>; // Assuming Geolocation is an array
    return AddressModel(
      building: data['Building'],
      floor: data['Floor'],
      geolocation: GeoLocationModel.fromFirestore(
          geolocationData), // Pass the array here
      landmark: data['Landmark'],
      location: data['Location'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Building': building,
      'Floor': floor,
      'Geolocation': [geolocation.lat, geolocation.lon], // Save as an array
      'Landmark': landmark,
      'Location': location,
    };
  }

  @override
  String toString() {
    return 'AddressModel(building: $building, floor: $floor, geolocation: $geolocation, landmark: $landmark, location: $location)';
  }
}

class GeoLocationModel {
  final String lat;
  final String lon;

  GeoLocationModel({
    required this.lat,
    required this.lon,
  });

  // Update this to use a List instead of Map
  factory GeoLocationModel.fromFirestore(List<dynamic> data) {
    return GeoLocationModel(
      lat: data[0].toString(),
      lon: data[1].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lat': lat,
      'lon': lon,
    };
  }

  @override
  String toString() {
    return 'GeoLocationModel(lat: $lat, lon: $lon)';
  }
}

Future<void> saveUserDetailsLocally(String email) async {
  try {
    // Fetch user details from Firestore using email
    var userDoc = await FirebaseFirestore.instance
        .collection('users_table')
        .where('email', isEqualTo: email)
        .get();

    if (userDoc.docs.isNotEmpty) {
      var userData = userDoc.docs.first.data();
      UserModel user = UserModel.fromFirestore(userData);
      String docId = userDoc.docs.first.id; // Get the document ID

      // Save user details in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userJson = jsonEncode(user.toMap());
      await prefs.setString('userDetails', userJson);
      await prefs.setString('userDocId', user.userId); // Save the document ID
      print('this is the data ${userJson}');
      print("User details saved successfully.");
    } else {
      print("No user found with this email.");
    }
  } catch (e) {
    print("Error saving user details: $e");
  }
}

Future<UserModel?> getUserDetailsFromLocal() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userDetails = prefs.getString('userDetails');

  if (userDetails != null) {
    // Convert the string back to Map and then to UserModel
    Map<String, dynamic> userMap = jsonDecode(userDetails);
    print('here is get data ${userMap}'); // Check the retrieved data
    try {
      UserModel user = UserModel.fromFirestore(userMap);
      print('Successfully decoded UserModel: ${user.name}');
      return user;
    } catch (e) {
      print('Error decoding UserModel: $e');
      return null;
    }
  } else {
    print('No user details found in SharedPreferences');
  }

  return null;
}
