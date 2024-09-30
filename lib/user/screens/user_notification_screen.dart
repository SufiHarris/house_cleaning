import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../auth/provider/auth_provider.dart';
import '../../theme/custom_colors.dart';
import '../widgets/notification_widgets.dart';
// Import the new NotificationItem widget

class UserNotifications extends StatelessWidget {
  const UserNotifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Get.find<AuthProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: CustomColors.Eggplant), // Brownish back icon
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Notifications",
          style: TextStyle(
            color: CustomColors.textColorThree, // Brownish title
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Today Section
            const Text(
              "TODAY",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.grey, // Brownish color for headings
              ),
            ),
            const SizedBox(height: 10),
            NotificationItem(
              icon: Icons.home_outlined,
              title: "Booking Confirmed!",
              subtitle:
                  "Home cleaning service for 4 rooms is scheduled for Mon - 14 Aug at 12:30 PM. Get ready for clean home.",
              time: "1h ago",
            ),
            NotificationItem(
              icon: Icons.home_outlined,
              title: "Service Completed :)",
              subtitle:
                  "Home cleaning service for 4 rooms is now complete. We hope you love your sparkling clean home.",
              time: "12:30 PM",
            ),
            NotificationItem(
              icon: Icons.home_outlined,
              title: "Service Cancelled :(",
              subtitle:
                  "Car cleaning service for your car has been cancelled. If you have any questions or need to reschedule, please contact our support team.",
              time: "Yesterday",
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.white, // White background for Re-Book button
                  side: BorderSide(
                      color: CustomColors.Eggplant), // Brownish border
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(51),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 130, vertical: 12),
                ),
                onPressed: () {
                  // Handle Re-Book action
                },
                child: Text(
                  "Re-Book",
                  style: TextStyle(
                    color: CustomColors.textColorThree, // Brownish text
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            // Yesterday Section
            const Text(
              "YESTERDAY",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.grey, // Brownish color for headings
              ),
            ),
            const SizedBox(height: 10),
            NotificationItem(
              icon: Icons.home_outlined,
              title: "Address Updated",
              subtitle:
                  "Your new address at 1234 King Fahd St has been updated in your account.",
              time: "2 days ago",
            ),
          ],
        ),
      ),
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         backgroundColor: Colors.white,
//         selectedItemColor: Color(0xFF4C2C24), // Brownish selected item color
//         unselectedItemColor: Colors.grey,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home_outlined),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.cleaning_services_outlined),
//             label: 'Services',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.production_quantity_limits_outlined),
//             label: 'Products',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.book_online_outlined),
//             label: 'Bookings',
//           ),
//         ],
//       ),
    );
  }
}
