import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class ClientDetailsController extends GetxController {
  var clientAddress = ''.obs;
  var landmark = ''.obs;
  var entryInstructions = ''.obs;
  var contactNumber = ''.obs;

  @override
  void onInit() {
    super.onInit();
    clientAddress.value = "123 Example Street";
    landmark.value = "Near the mall";
    entryInstructions.value = "Ring the doorbell";
    contactNumber.value = "+1234567890";

    // fetchClientDetails();
  }

//   void fetchClientDetails() async {
//     try {
//       DocumentSnapshot snapshot = await FirebaseFirestore.instance
//           .collection('size_based_bookings')
//           .doc('0xm1mKrOmvKV2tJL5tUX') // Replace with the actual document ID
//           .get();

//       // Assuming clientAddress is stored as GeoPoint
//       GeoPoint geoPoint = snapshot['Geolocation'];
//       double latitude = geoPoint.latitude;
//       double longitude = geoPoint.longitude;

//       List<Placemark> placemarks =
//           await placemarkFromCoordinates(latitude, longitude);
//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks[0];
//         clientAddress.value =
//             "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
//       }

//       landmark.value = snapshot['landmark'];
//       // entryInstructions.value = snapshot['entryInstructions'];
//       contactNumber.value = snapshot['user_phn_number'];
//     } catch (e) {
//       print("Error fetching client details: $e");
//     }
//   }
}
