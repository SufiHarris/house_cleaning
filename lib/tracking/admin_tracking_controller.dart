import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:house_cleaning/tracking/tracking_models/employee_model.dart';

class AdminTrackingController extends GetxController {
  var employees = <Employee>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEmployees();
  }

  void fetchEmployees() {
    // Hardcoded document ID for the employee
    String documentId =
        'ya6nkjEN9IoMmAoL4DJx'; // Replace with your actual document ID

    // Listen to real-time updates for the specific document
    FirebaseFirestore.instance
        .collection('employee_locations')
        .doc(documentId)
        .snapshots()
        .listen((docSnapshot) {
      if (docSnapshot.exists) {
        final data = docSnapshot.data();

        // Log the fetched data to check if it exists
        print("Fetched Employee Data: $data");

        // Update employees list with only one employee (as we are fetching by document ID)
        employees.value = [
          Employee.fromJson({
            'id': docSnapshot.id,
            'name': data?['name'],
            'geolocations': LatLng(
              data?['geolocations']['latitude'],
              data?['geolocations']['longitude'],
            ),
            'totalTimeTaken': data?['totalTimeTaken'],
          }),
        ];
        isLoading.value = false; // Stop loading when data is fetched
      } else {
        print('No employee location found for ID: $documentId');
        isLoading.value = false; // Stop loading even if no data is found
      }
    }, onError: (error) {
      print("Error fetching employee location: $error");
      isLoading.value = false;
    });
  }
}
