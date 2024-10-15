// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:house_cleaning/tracking/admin_tracking_controller.dart';

// class AdminTrackingScreen extends StatelessWidget {
//   final AdminTrackingController trackingController =
//       Get.put(AdminTrackingController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Employee Tracking')),
//       body: Obx(() {
//         if (trackingController.isLoading.value) {
//           return Center(child: CircularProgressIndicator());
//         }

//         if (trackingController.employees.isEmpty) {
//           return Center(child: Text('No employees to track.'));
//         }

//         // Safely access the first employee's position for initial map positioning
//         final initialPosition = trackingController.employees.first.geolocations;

//         return GoogleMap(
//           initialCameraPosition: CameraPosition(
//             target: initialPosition,
//             zoom: 12,
//           ),
//           markers: trackingController.employees.map((employee) {
//             return Marker(
//               markerId: MarkerId(employee.id),
//               position: employee.geolocations,
//               infoWindow: InfoWindow(
//                 title: employee.name,
//                 snippet:
//                     'Time taken: ${employee.totalTimeTaken?.inMinutes ?? 0} mins',
//               ),
//             );
//           }).toSet(),
//         );
//       }),
//     );
//   }
// }
