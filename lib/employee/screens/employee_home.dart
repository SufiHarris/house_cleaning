import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/auth/provider/auth_provider.dart';
import 'package:house_cleaning/employee/provider/employee_provider.dart';
import 'package:house_cleaning/employee/screens/add_employee_screen.dart';
import 'package:house_cleaning/employee/widgets/employee_booking_card.dart';
import 'package:house_cleaning/user/widgets/heading_text.dart';
import '../../theme/custom_colors.dart';
import '../../user/models/bookings_model.dart';

import '../widgets/employee_card.dart';
import 'employee_booking_detail.dart';

class EmployeeHome extends StatelessWidget {
  const EmployeeHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Get.find<AuthProvider>();
    final employeeProvider = Get.find<EmployeeProvider>();

    // Load staff details when the widget is built
    employeeProvider.loadStaffDetails();

    // Fetch employee bookings
    employeeProvider.fetchEmployeeBookings();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // Header
            Container(
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
                                    ?.copyWith(
                                        color: CustomColors.textColorTwo),
                              )),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      authProvider.signOut();
                      //Get.to(() => AddEmployeeScreen());
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
            ),

            // Employee Card
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(() => EmployeeCard(
                    name: employeeProvider.staffDetails.value?.name ??
                        "Loading...",
                    imageUrl: employeeProvider.staffDetails.value?.image ??
                        "https://placeholder.com/150",
                    number:
                        employeeProvider.staffDetails.value?.phoneNumber ?? 0,
                    experience:
                        '4 years', // You might want to add this to your StaffModel
                  )),
            ),
            SizedBox(height: 10),
            Divider(),

            // Tab Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  HeadingText(headingText: "Assigned tasks"),
                  Obx(() {
                    final todayBookings =
                        _filterTodayBookings(employeeProvider.employeeBookings);
                    final assignedBookings = _filterAssignedBookings(
                        employeeProvider.employeeBookings);

                    return TabBar(
                      tabs: [
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  shape: BoxShape.circle,
                                ),
                                child: Text('${todayBookings.length}'),
                              ),
                              SizedBox(width: 8),
                              Text('Today'),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  shape: BoxShape.circle,
                                ),
                                child: Text('${assignedBookings.length}'),
                              ),
                              SizedBox(width: 8),
                              Text('Assigned'),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),

            // Tab Bar View
            Expanded(
              child: Obx(() {
                final todayBookings =
                    _filterTodayBookings(employeeProvider.employeeBookings);
                final assignedBookings =
                    _filterAssignedBookings(employeeProvider.employeeBookings);

                return TabBarView(
                  children: [
                    // Today's Tasks
                    _buildBookingsList(todayBookings),
                    // Assigned Tasks (Non-Today)
                    _buildBookingsList(assignedBookings),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods remain the same...
  List<BookingModel> _filterTodayBookings(List<BookingModel> bookings) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return bookings.where((booking) {
      final bookingDate = DateTime.parse(booking.bookingDate);
      final bookingDayOnly =
          DateTime(bookingDate.year, bookingDate.month, bookingDate.day);
      return bookingDayOnly == today;
    }).toList();
  }

  List<BookingModel> _filterAssignedBookings(List<BookingModel> bookings) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return bookings.where((booking) {
      final bookingDate = DateTime.parse(booking.bookingDate);
      final bookingDayOnly =
          DateTime(bookingDate.year, bookingDate.month, bookingDate.day);
      return bookingDayOnly.isAfter(today);
    }).toList();
  }

  Widget _buildBookingsList(List<BookingModel> bookings) {
    if (bookings.isEmpty) {
      return Center(child: Text("No tasks available"));
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            GestureDetector(
              onTap: () => {
                Get.to(
                  EmployeeBookingDetail(booking: bookings[index]),
                ),
              },
              child: EmployeeBookingCard(
                booking: bookings[index],
              ),
            ),
            Divider(),
          ],
        );
      },
    );
  }
}
