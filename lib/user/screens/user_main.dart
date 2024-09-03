import 'package:flutter/material.dart';
import 'package:house_cleaning/user/screens/user_bookings.dart';
import 'package:house_cleaning/user/screens/user_settings.dart';
import 'user_home.dart';
import 'user_service_screen.dart';
import 'user_product_screen.dart';

class UserMain extends StatefulWidget {
  const UserMain({super.key});

  @override
  State<UserMain> createState() => _UserMainState();
}

class _UserMainState extends State<UserMain> {
  int currentIndex = 0;
  final List<Widget> screens = const [
    UserHome(),
    UserServiceScreen(),
    UserProductScreen(),
    UserBookings(),
    UserSettings()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sell),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_view_month_outlined),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
