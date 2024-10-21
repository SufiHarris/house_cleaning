import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../employee/screens/employee_address_details.dart';
import '../general_functions/booking_status.dart';
import '../generated/l10n.dart';
import '../theme/custom_colors.dart';
import '../user/models/bookings_model.dart';
import 'tracking_controller.dart';

class EmployeeTrackingMap extends StatelessWidget {
  final BookingModel booking;

  EmployeeTrackingMap({Key? key, required this.booking}) : super(key: key);

  final BookingController bookingController = Get.find<BookingController>();

  @override
  Widget build(BuildContext context) {
    final trackingController = Get.find<EmployeeTrackingController>();

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
                zoom: 18,
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
          Positioned(
            bottom: 90,
            left: 30,
            right: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                                  S.of(context).remaining,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                          SizedBox(height: 4),
                          Text(
                            '${trackingController.totalDistance.value.toStringAsFixed(2)} ${S.of(context).kms}', // Localized 'Km\'s'
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: CustomColors.textColorThree,
                            ),
                          ),
                        ],
                      ),
                    )),
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
                                  S.of(context).etaTime,
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
                  S.of(context).reached,
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
