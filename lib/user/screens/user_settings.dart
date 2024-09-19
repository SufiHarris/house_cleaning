import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/theme/custom_colors.dart';
import 'package:house_cleaning/user/widgets/setting_widget.dart';

import '../../auth/provider/auth_provider.dart';

class UserSettings extends StatelessWidget {
  const UserSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Get.find<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Profile"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage('assets/images/UserProfile-Pic.png'),
          ),
          Positioned(
            bottom: 0,
            right: 100,
            child: CircleAvatar(
              backgroundColor: Color(0xFF6B3F3A),
              radius: 16,
              child: Icon(Icons.edit, size: 18, color: Colors.white),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Jubayl Bin Meenak',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6B3F3A),
            ),
          ),
          SizedBox(height: 30),
          ProfileMenuItem(
            svgIconPath: 'assets/images/Profile-Pic.svg',
            text: "My Profile",
            onTap: () {},
          ),
          ProfileMenuItem(
            svgIconPath: 'assets/images/Profile-Address.svg',
            text: "Manage Address",
            onTap: () {},
          ),
          ProfileMenuItem(
            svgIconPath: 'assets/images/Profile-Password.svg',
            text: "Change Password",
            onTap: () {},
          ),
          ProfileMenuItem(
            svgIconPath: 'assets/images/Profile-T&C.svg',
            text: "Terms & Conditions",
            onTap: () {},
          ),
          ProfileMenuItem(
            svgIconPath: 'assets/images/Profile-Privacy.svg',
            text: "Privacy Policy",
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
