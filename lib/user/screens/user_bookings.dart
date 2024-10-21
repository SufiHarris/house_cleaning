import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/user/screens/user_bookings_detail_page.dart';
import '../../generated/l10n.dart';
import '../providers/user_provider.dart';
import '../widgets/user_booking_widget.dart';

class UserBookings extends StatelessWidget {
  const UserBookings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Get.find();
    userProvider.fetchBookings();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).bookings),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Current'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildCurrentBookingsList(userProvider),
            _buildBookingsList(userProvider, ['completed']),
            _buildBookingsList(userProvider, ['cancelled']),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentBookingsList(UserProvider userProvider) {
    return Obx(() {
      if (userProvider.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      // Filter bookings for "In Progress" section
      final inProgressBookings = userProvider.bookings
          .where((booking) =>
              ['inprogress', 'working'].contains(booking.status.toLowerCase()))
          .toList();

      // Filter bookings for "Scheduled" section
      final scheduledBookings = userProvider.bookings
          .where((booking) =>
              ['unassigned', 'assigned'].contains(booking.status.toLowerCase()))
          .toList();

      return ListView(
        padding: EdgeInsets.all(16),
        children: [
          if (inProgressBookings.isNotEmpty) ...[
            Text('ONGOING', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            ...inProgressBookings.map(
              (booking) => GestureDetector(
                onTap: () => Get.to(UserBookingDetailsPage(booking: booking)),
                child: UserBookingWidget(booking: booking),
              ),
            ),
            SizedBox(height: 16),
          ],
          if (scheduledBookings.isNotEmpty) ...[
            Text('SCHEDULED', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            ...scheduledBookings.map(
              (booking) => GestureDetector(
                onTap: () => Get.to(UserBookingDetailsPage(booking: booking)),
                child: UserBookingWidget(booking: booking),
              ),
            ),
          ],
        ],
      );
    });
  }

  Widget _buildBookingsList(UserProvider userProvider, List<String> statuses) {
    return Obx(() {
      if (userProvider.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      final filteredBookings = userProvider.bookings
          .where((booking) => statuses.contains(booking.status.toLowerCase()))
          .toList();

      return ListView(
        padding: EdgeInsets.all(16),
        children: [
          if (filteredBookings.isNotEmpty) ...[
            Text(statuses.first.toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            ...filteredBookings.map(
              (booking) => GestureDetector(
                onTap: () => Get.to(UserBookingDetailsPage(booking: booking)),
                child: UserBookingWidget(booking: booking),
              ),
            )
          ],
        ],
      );
    });
  }
}
