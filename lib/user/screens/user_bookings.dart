import 'package:flutter/material.dart';
import 'package:house_cleaning/user/widgets/booking_widget.dart';

import '../models/booking_model.dart';

class UserBookings extends StatefulWidget {
  const UserBookings({super.key});

  @override
  _UserBookingsState createState() => _UserBookingsState();
}

class _UserBookingsState extends State<UserBookings>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<Booking> bookings;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    bookings = generateSampleBookings(); // Initialize sample data
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Filter bookings based on their status
  List<Booking> _filterBookings(String status) {
    return bookings.where((booking) => booking.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTabView('Pending'), // Pending bookings
          _buildTabView('Completed'), // Completed bookings
          _buildTabView('Cancelled'), // Cancelled bookings
        ],
      ),
    );
  }

  Widget _buildTabView(String status) {
    List<Booking> filteredBookings = _filterBookings(status);

    return ListView.builder(
      itemCount: filteredBookings.length,
      itemBuilder: (context, index) {
        return BookingWidget(
          booking: filteredBookings[index],
        );
      },
    );
  }
}
