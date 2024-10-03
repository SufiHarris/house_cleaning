import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/auth/screens/auth_screen.dart';
import 'package:house_cleaning/auth/screens/staff_login.dart';

class SegerationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/images/auth_screen_bg.png',
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Column(
              children: [
                // Status Bar (Time)
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '9:41',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                // Statistics Cards
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard('1.2K+', 'Monthly\nSubscribers'),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard('100K', 'Positive\nReviews'),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                // Continue As Text
                Text(
                  'Continue As',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                // Client Button
                _buildRoleButton('Client', Icons.person),
                SizedBox(height: 16),
                // Staff Button
                _buildRoleButton('Staff', Icons.work),
                SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.brown.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleButton(String label, IconData icon) {
    return GestureDetector(
      onTap: () {
        if (label == "Staff") {
          Get.to(StaffLogin());
        } else {
          Get.to(AuthScreen());
        }
      },
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.all(Radius.circular(50))),
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon),
                SizedBox(
                  width: 10,
                ),
                Text(label)
              ],
            ),
          )),
    );
  }
}
