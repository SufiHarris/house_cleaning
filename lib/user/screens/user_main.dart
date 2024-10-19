import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import 'user_bookings.dart';
import 'user_home.dart';
import 'user_service_screen.dart';
import 'user_product_screen.dart';
import 'user_settings.dart';

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
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: S.of(context).home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: S.of(context).services,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sell),
            label: S.of(context).products,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_view_month_outlined),
            label: S.of(context).bookings,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: S.of(context).settings,
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
