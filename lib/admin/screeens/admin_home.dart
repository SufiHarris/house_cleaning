import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/admin/widget/admin_booking_card.dart';
import 'package:house_cleaning/auth/provider/auth_provider.dart';
import 'package:house_cleaning/employee/provider/employee_provider.dart';
import 'package:house_cleaning/notifications/notifications.dart';
import 'package:house_cleaning/user/screens/user_bookings_detail_page.dart';
import 'package:house_cleaning/user/widgets/heading_text.dart';
import '../../theme/custom_colors.dart';
import '../provider/admin_provider.dart';
import '../widget/hero_cards.dart';
import 'admin_booking_detail_page.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Get.find<AuthProvider>();
    final employeeProvider = Get.find<EmployeeProvider>();
    final adminProvider = Get.find<AdminProvider>();

    employeeProvider.loadStaffDetails();
    employeeProvider.fetchEmployeeBookings();
    adminProvider.fetchBookings(DateTime.now().year);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            _buildHeader(context, employeeProvider, authProvider),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildHeroCards(adminProvider),
                      SizedBox(height: 20),
                      _buildNewBookingsHeader(context),
                      _buildBookingsList(adminProvider),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, EmployeeProvider employeeProvider,
      AuthProvider authProvider) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Row(
        children: [
          Row(
            children: [
              SizedBox(
                child: SvgPicture.asset("assets/images/logo.svg"),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome",
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(color: CustomColors.textColorFour),
                  ),
                  Obx(() => Text(
                        employeeProvider.staffDetails.value?.name ??
                            "Loading...",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: CustomColors.textColorTwo),
                      )),
                ],
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () async {
              authProvider.signOut();
              // print("Bell icon tapped"); // Debugging statement
              // try {
              //   // Attempt to send a notification
              //   await PushNotifications.sendNotificationToUsers(
              //       "Admin Alert!", "Check out the latest announcement!");
              //   print("Notification sent successfully!");
              // } catch (e) {
              //   print("Error sending notification: $e");
              // }
            },
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SvgPicture.asset("assets/images/icon_bell.svg"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCards(AdminProvider adminProvider) {
    return Obx(() {
      final counts = adminProvider.getBookingCounts();
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HeroCard(
                  number: counts['completed'].toString(),
                  status: 'Completed',
                  iconName: 'assets/images/completed.svg'),
              HeroCard(
                  number: counts['inProcess'].toString(),
                  status: 'In-Process',
                  iconName: 'assets/images/in_process.svg'),
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HeroCard(
                  number: counts['unAssigned'].toString(),
                  status: 'Un-Assigned',
                  iconName: 'assets/images/un_assigned.svg'),
              HeroCard(
                  number: counts['cancelled'].toString(),
                  status: 'Cancelled',
                  iconName: 'assets/images/cancelled.svg'),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildNewBookingsHeader(BuildContext context) {
    return Row(
      children: [
        Text(
          "New Bookings",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Spacer(),
        GestureDetector(
          child: Row(
            children: [
              Text(
                'View All',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: CustomColors.primaryColor,
                    fontWeight: FontWeight.w500),
              ),
              Icon(
                Icons.chevron_right,
                color: CustomColors.primaryColor,
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildBookingsList(AdminProvider adminProvider) {
    return Obx(() {
      if (adminProvider.isLoading.value) {
        return Column(
          children: [
            SizedBox(
              height: 150,
            ),
            Center(child: CircularProgressIndicator()),
          ],
        );
      }

      if (adminProvider.bookings.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.event_busy,
                  size: 64,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16),
                Text(
                  "No bookings available",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "There are currently no new bookings to display.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: adminProvider.bookings.length,
        itemBuilder: (context, index) {
          final booking = adminProvider.bookings[index];
          return GestureDetector(
            onTap: () => Get.to(AdminBookingDetailPage(booking: booking)),
            child: AdminBookingCard(
              booking: booking,
              adminProvider: adminProvider,
            ),
          );
        },
      );
    });
  }
}
