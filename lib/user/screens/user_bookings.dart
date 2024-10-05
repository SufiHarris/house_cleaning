import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/booking_model.dart';
import '../models/bookings_model.dart';
import '../providers/user_provider.dart';

class UserBookings extends StatelessWidget {
  const UserBookings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Get.find<UserProvider>();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Bookings'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'In Process'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildBookingsList(userProvider, 'In-Process'),
            _buildBookingsList(userProvider, 'Completed'),
            _buildBookingsList(userProvider, 'Cancelled'),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsList(UserProvider userProvider, String status) {
    return Obx(() {
      if (userProvider.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }
      final inProcessBookings = userProvider.bookings
          .where((booking) => booking.status == status)
          .toList();
      final upcomingBookings = userProvider.bookings
          .where((booking) => booking.status == 'pending')
          .toList();

      return ListView(
        padding: EdgeInsets.all(16),
        children: [
          if (inProcessBookings.isNotEmpty) ...[
            Text('STARTED', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            ...inProcessBookings.map((booking) => _buildBookingCard(booking)),
          ],
          if (upcomingBookings.isNotEmpty) ...[
            SizedBox(height: 16),
            Text('SCHEDULED', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            ...upcomingBookings.map((booking) => _buildBookingCard(booking)),
          ],
        ],
      );
    });
  }

  Widget _buildBookingCard(BookingModel booking) {
    String serviceName = booking.services.isNotEmpty
        ? booking.services[0].service_name
        : 'Unknown Service';
    String startDate = _formatDate(booking.bookingDate);
    String endDate = _formatDate(booking
        .bookingDate); // Assuming end date is same as start for simplicity

    return Card(
      color: booking.status == 'In-Process'
          ? Colors.blue.shade50
          : Colors.yellow.shade50,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _getServiceIcon(serviceName),
                    SizedBox(width: 8),
                    Text(serviceName,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                Text(booking.status,
                    style: TextStyle(
                        color: booking.status == 'In-Process'
                            ? Colors.blue
                            : Colors.orange)),
              ],
            ),
            SizedBox(height: 8),
            Text('${booking.total_price} SAR',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Started'),
                    Text(startDate,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    color: Colors.grey,
                    margin: EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Ending'),
                    Text(endDate,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            if (booking.status == 'In-Process') ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                child: Text('Track'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 36),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _getServiceIcon(String serviceName) {
    IconData iconData;
    switch (serviceName.toLowerCase()) {
      case 'apartment cleaning':
        iconData = Icons.home;
        break;
      case 'vehicle cleaning':
        iconData = Icons.directions_car;
        break;
      case 'facades cleaning':
        iconData = Icons.business;
        break;
      default:
        iconData = Icons.cleaning_services;
    }
    return Icon(iconData, size: 24);
  }

  String _formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    if (dateTime.isToday()) {
      return 'Today';
    } else {
      return DateFormat('E - dd MMM').format(dateTime);
    }
  }
}

extension DateTimeExtension on DateTime {
  bool isToday() {
    final now = DateTime.now();
    return now.day == this.day &&
        now.month == this.month &&
        now.year == this.year;
  }
}
