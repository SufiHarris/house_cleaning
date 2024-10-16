import 'package:flutter/material.dart';
import 'package:house_cleaning/admin/screeens/admin_bookings.dart';
import 'package:house_cleaning/admin/screeens/admin_home.dart';
import 'package:house_cleaning/admin/screeens/admin_management.dart';

import '../../user/screens/user_bookings.dart';
import '../../user/screens/user_product_screen.dart';
import '../../user/screens/user_service_screen.dart';
import '../../user/screens/user_settings.dart';

class AdminMain extends StatefulWidget {
  const AdminMain({super.key});
  @override
  State<AdminMain> createState() => _AdminMainState();
}

class _AdminMainState extends State<AdminMain> {
  int currentIndex = 0;
  final List<Widget> screens = [
    const AdminHome(),
    BookingManagementScreen(),
    const AdminManagement(),
    const UserBookings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: screens[currentIndex], // Display the current screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index < screens.length) {
            setState(() {
              currentIndex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sell),
            label: 'Manage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_view_month_outlined),
            label: 'Analytics',
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
