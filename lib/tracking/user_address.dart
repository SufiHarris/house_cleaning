import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<LatLng?> getUserAddress(String userId) async {
    var addressSnapshot = await _firestore
        .collection('users_table')
        .doc('SmmKMTVkMvHGEa0BB92I')
        .collection('addresses')
        .get();

    if (addressSnapshot.docs.isNotEmpty) {
      var data = addressSnapshot.docs.first.data();
      GeoPoint geoPoint =
          data['geolocation']; // Assuming `location` is a GeoPoint
      return LatLng(geoPoint.latitude, geoPoint.longitude);
    }

    return null;
  }
}
