import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/theme/custom_colors.dart';
// import 'package:house_cleaning/user/widgets/profile_widgets.dart';

import '../../auth/provider/auth_provider.dart';
import '../widgets/Profile_widgets.dart'; // Import the combined widget file

class EditProfile extends StatelessWidget {
  const EditProfile({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Get.find<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xFF6B3F3A)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(color: CustomColors.textColorThree),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              ProfileHeader(
                imagePath: 'assets/images/UserProfile-Pic.png',
                name: 'Jubayl Bin Meenak',
              ),
              SizedBox(height: 30),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Personal details',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF6B3F3A),
                  ),
                ),
              ),
              SizedBox(height: 10),
              ProfileTextField(label: 'Saad Al Nayem'),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Phone Number',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF6B3F3A),
                  ),
                ),
              ),
              SizedBox(height: 10),
              ProfilePhoneField(),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF6B3F3A),
                  ),
                ),
              ),
              SizedBox(height: 10),
              ProfileTextField(label: 'saadalnayem@gmail.com'),
              SizedBox(height: 80),
              ProfileButton(
                onPressed: () {
                  // Handle profile update logic here
                  // For example: validate form, send data to server, etc.
                },
                buttonText: "Update Profile",
                buttonColor: CustomColors.textColorThree,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
