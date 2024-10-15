import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/admin/provider/admin_provider.dart';
import 'package:house_cleaning/user/models/bookings_model.dart';

import '../widget/admin_booking_card.dart';

class BookingManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Booking Management'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'New Bookings'),
              Tab(text: 'On Going'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            BookingList(status: 'unassigned'),
            BookingList(status: 'ongoing'),
            BookingList(status: 'completed'),
          ],
        ),
      ),
    );
  }
}

class BookingList extends StatelessWidget {
  final String status;

  BookingList({required this.status});

  @override
  Widget build(BuildContext context) {
    final adminProvider = Get.find<AdminProvider>();

    return Obx(() {
      if (adminProvider.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      final filteredBookings = adminProvider.bookings.where((booking) {
        switch (status) {
          case 'unassigned':
            return booking.status.toLowerCase() == 'unassigned';
          case 'ongoing':
            return ['in progress', 'working', 'pending', 'assigned']
                .contains(booking.status.toLowerCase());
          case 'completed':
            return booking.status.toLowerCase() == 'completed';
          default:
            return false;
        }
      }).toList();

      if (filteredBookings.isEmpty) {
        return Center(child: Text('No bookings found'));
      }

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: filteredBookings.length,
          itemBuilder: (context, index) {
            return AdminBookingCard(
              booking: filteredBookings[index],
              adminProvider: adminProvider,
            );
          },
        ),
      );
    });
  }
}
