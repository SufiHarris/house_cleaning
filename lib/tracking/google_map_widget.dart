import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../employee/screens/employee_address_details.dart';
import '../general_functions/booking_status.dart';
import '../theme/custom_colors.dart';
import '../user/models/bookings_model.dart';
import 'tracking_controller.dart';

class EmployeeTrackingMap extends StatelessWidget {
  final BookingModel booking;

  // Constructor to accept the booking model
  EmployeeTrackingMap({Key? key, required this.booking}) : super(key: key);

  // Declare your controller here
  final BookingController bookingController = Get.find<
      BookingController>(); // Use Get.find() to avoid multiple instances.

  @override
  Widget build(BuildContext context) {
    // Ensure the tracking controller is initialized
    final trackingController = Get.find<EmployeeTrackingController>();

    // Set client location if geolocation is not null
    if (booking.geolocation != null) {
      double clientLat = double.parse(booking.geolocation.lat);
      double clientLon = double.parse(booking.geolocation.lon);
      trackingController.setClientLocation(LatLng(clientLat, clientLon));
    }

    return Scaffold(
      body: Stack(
        children: [
          Obx(() {
            if (trackingController.currentPosition.value == null) {
              return Center(child: CircularProgressIndicator());
            }
            LatLng employeeLocation = LatLng(
              trackingController.currentPosition.value!.latitude,
              trackingController.currentPosition.value!.longitude,
            );

            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: employeeLocation,
                // target: LatLng(
                //   double.parse(booking.geolocation.lat),
                //   double.parse(booking.geolocation.lon),
                // ),
                zoom: 18,
                // tilt: 20,
                // bearing: trackingController.currentPosition.value,
              ),
              polylines: {
                Polyline(
                  polylineId: PolylineId('route'),
                  points: trackingController.polylineCoordinates,
                  color: Colors.blue,
                  width: 6,
                ),
              },
              markers: trackingController.markers.toSet(),
              onMapCreated: (GoogleMapController controller) {
                trackingController.mapController = controller;
                trackingController.moveMapToCurrentPosition();
              },
            );
          }),

          // Landmark and address
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.location_pin, color: CustomColors.textColorThree),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.landmark,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        booking.address,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: CustomColors.textColorThree,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Remaining Distance and ETA
          Positioned(
            bottom: 90,
            left: 30,
            right: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Remaining distance container
                Obx(() => Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.directions_walk,
                              color: CustomColors.textColorThree),
                          SizedBox(height: 8),
                          trackingController.isLoadingRemainingDistance.value
                              ? Center(child: CircularProgressIndicator())
                              : Text(
                                  'Remaining',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                          SizedBox(height: 4),
                          Text(
                            '${trackingController.totalDistance.value.toStringAsFixed(2)} Km\'s',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: CustomColors.textColorThree,
                            ),
                          ),
                        ],
                      ),
                    )),
                // ETA container
                Obx(() => Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.access_time,
                              color: CustomColors.textColorThree),
                          SizedBox(height: 8),
                          trackingController.isLoadingETA.value
                              ? Center(child: CircularProgressIndicator())
                              : Text(
                                  'ETA Time',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                          SizedBox(height: 4),
                          Text(
                            '${trackingController.eta.value}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: CustomColors.textColorThree,
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),

      // Bottom sheet for "Reached" button
      bottomSheet: Obx(() => Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: trackingController.hasReachedDestination.value
                    ? () {
                        bookingController.updateBookingStatus(
                            booking.booking_id.toString(), 'working');
                        Get.to(() => ClientDetailsPage(booking: booking));
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      trackingController.hasReachedDestination.value
                          ? CustomColors.textColorThree
                          : Colors.grey,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "Reached",
                  style: TextStyle(
                    fontSize: 16,
                    color: trackingController.hasReachedDestination.value
                        ? Colors.white
                        : Color(0xFFBDBDBD),
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
