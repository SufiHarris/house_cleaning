import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/auth/model/usermodel.dart';
import 'package:house_cleaning/user/screens/T&C_screen.dart';
import 'package:house_cleaning/user/screens/change_password.dart';
import 'package:house_cleaning/user/screens/manage_address.dart';
import 'package:house_cleaning/user/screens/privacy_policy_screen.dart';
import 'package:house_cleaning/user/screens/user_profile.dart';
import 'package:house_cleaning/user/widgets/setting_widget.dart';
import '../../auth/provider/auth_provider.dart';

class UserSettings extends StatelessWidget {
  const UserSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Get.find<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: FutureBuilder<UserModel?>(
        future: getUserDetailsFromLocal(), // Fetch user details
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error fetching user details'));
          }

          final user = snapshot.data;

          if (user == null) {
            return Center(child: Text('No user details found.'));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        AssetImage('assets/images/UserProfile-Pic.png'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Color(0xFF6B3F3A),
                      radius: 16,
                      child: Icon(Icons.edit, size: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                user.name, // Use the user's name from the retrieved data
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
                onTap: () {
                  Get.to(() => UserProfile());
                },
              ),
              Divider(thickness: 0.5, color: Colors.grey[300]),
              ProfileMenuItem(
                svgIconPath: 'assets/images/Profile-Address.svg',
                text: "Manage Address",
                onTap: () {
                  Get.to(() => ManageAddress());
                },
              ),
              Divider(thickness: 0.5, color: Colors.grey[300]),
              ProfileMenuItem(
                svgIconPath: 'assets/images/Profile-Password.svg',
                text: "Change Password",
                onTap: () {
                  Get.to(() => ChangePassword());
                },
              ),
              Divider(thickness: 0.5, color: Colors.grey[300]),
              ProfileMenuItem(
                svgIconPath: 'assets/images/Profile-T&C.svg',
                text: "Terms & Conditions",
                onTap: () {
                  Get.to(() => TermsAndConditionsPage());
                },
              ),
              Divider(thickness: 0.5, color: Colors.grey[300]),
              ProfileMenuItem(
                svgIconPath: 'assets/images/Profile-Privacy.svg',
                text: "Privacy Policy",
                onTap: () {
                  Get.to(() => PrivacyPolicyPage());
                },
              ),
              const Spacer(),
              ElevatedButton(
                  style: ButtonStyle(
                    fixedSize:
                        MaterialStateProperty.all(Size(double.infinity, 30)),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: () {
                    authProvider.signOut();
                  },
                  child: const Text("Log out"))
            ],
          );
        },
      ),
    );
  }
}
