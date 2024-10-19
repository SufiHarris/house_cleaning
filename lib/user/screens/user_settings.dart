import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/auth/model/usermodel.dart';
import 'package:house_cleaning/user/screens/T&C_screen.dart';
import 'package:house_cleaning/user/screens/manage_address.dart';
import 'package:house_cleaning/user/screens/privacy_policy_screen.dart';
import 'package:house_cleaning/user/screens/user_profile.dart';
import 'package:house_cleaning/user/widgets/setting_widget.dart';
import '../../auth/provider/auth_provider.dart';
import '../../generated/l10n.dart';
import 'change_password_screen.dart';

class UserSettings extends StatelessWidget {
  const UserSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Get.find<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).settings),
        actions: [
          IconButton(
            icon: Icon(Icons.language),
            onPressed: () {
              // Toggle language between Arabic and English
              if (Get.locale == Locale('en', '')) {
                Get.updateLocale(Locale('ar', ''));
              } else {
                Get.updateLocale(Locale('en', ''));
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<UserModel?>(
        future: getUserDetailsFromLocal(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(S.of(context).errorFetchingUserDetails));
          }

          final user = snapshot.data;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: user != null
                        ? AssetImage('assets/images/UserProfile-Pic.png')
                        : AssetImage(
                            'assets/images/placeholder-profile.png'), // Placeholder image
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
                user?.name ?? S.of(context).guestUser,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6B3F3A),
                ),
              ),
              SizedBox(height: 30),
              ProfileMenuItem(
                svgIconPath: 'assets/images/Profile-Pic.svg',
                text: S.of(context).myProfile,
                onTap: () {
                  Get.to(() => UserProfile());
                },
              ),
              Divider(thickness: 0.5, color: Colors.grey[300]),
              ProfileMenuItem(
                svgIconPath: 'assets/images/Profile-Address.svg',
                text: S.of(context).manageAddress,
                onTap: () {
                  Get.to(() => ManageAddress());
                },
              ),
              Divider(thickness: 0.5, color: Colors.grey[300]),
              ProfileMenuItem(
                svgIconPath: 'assets/images/Profile-Password.svg',
                text: S.of(context).changePassword, // Localized menu item
                onTap: () {
                  Get.to(() => ChangePassword());
                },
              ),
              Divider(thickness: 0.5, color: Colors.grey[300]),
              ProfileMenuItem(
                svgIconPath: 'assets/images/Profile-T&C.svg',
                text: S.of(context).termsAndConditions, // Localized menu item
                onTap: () {
                  Get.to(() => TermsAndConditionsPage());
                },
              ),
              Divider(thickness: 0.5, color: Colors.grey[300]),
              ProfileMenuItem(
                svgIconPath: 'assets/images/Profile-Privacy.svg',
                text: S.of(context).privacyPolicy, // Localized menu item
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
                child: Text(S.of(context).logOut), // Localized log out button
              ),
            ],
          );
        },
      ),
    );
  }
}
