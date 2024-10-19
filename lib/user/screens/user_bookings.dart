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
    final UserProvider userProvider = Get.find<UserProvider>();
    userProvider.fetchBookings();
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).bookings),
          bottom: TabBar(
            tabs: [
              Tab(text: S.of(context).inProcess),
              Tab(text: S.of(context).completed),
              Tab(text: S.of(context).cancelled),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildBookingsList(userProvider, 'pending'),
            _buildBookingsList(userProvider, 'completed'),
            _buildBookingsList(userProvider, 'cancelled'),
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
      final filteredBookings = userProvider.bookings
          .where(
              (booking) => booking.status.toLowerCase() == status.toLowerCase())
          .toList();

      return ListView(
        padding: EdgeInsets.all(16),
        children: [
          if (filteredBookings.isNotEmpty) ...[
            Text(status.toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            ...filteredBookings.map(
              (booking) => GestureDetector(
                onTap: () => {Get.to(UserBookingDetailsPage(booking: booking))},
                child: UserBookingWidget(booking: booking),
              ),
            )
          ],
        ],
      );
    });
  }
}
