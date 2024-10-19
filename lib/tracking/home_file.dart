import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/tracking/admin_tracking.dart';
import 'package:house_cleaning/tracking/client_tracking_map.dart';
import 'package:house_cleaning/tracking/google_map_widget.dart';
import 'package:house_cleaning/tracking/tracking_controller.dart';

class HomeFile extends StatelessWidget {
  const HomeFile({super.key});

  @override
  Widget build(BuildContext context) {
    // final EmployeeTrackingController employeeTrackingController =
    //     Get.put(EmployeeTrackingController());
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  // employeeTrackingController.startTracking();
                  // Get.to(() => EmployeeTrackingMap());
                },
                child: Text("Employee View")),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  Get.to(() => ClientTrackingMap());
                },
                child: Text("Client View")),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  Get.to(() => ClientTrackingMap());
                },
                child: Text("Admin View")),
            SizedBox(),
          ],
        ),
      ),
    );
  }
}
