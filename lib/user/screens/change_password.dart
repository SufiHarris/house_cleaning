import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/provider/auth_provider.dart';
import '../../theme/custom_colors.dart';
import '../widgets/changepassword_widget.dart';
import '../widgets/custom_button_widget.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({super.key});
  final TextEditingController currentpasswordController =
      TextEditingController();
  final TextEditingController newpasswordController = TextEditingController();
  final TextEditingController reEnterpasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Get.find<AuthProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text("Change Password")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50), // Space from top
            Text(
              "Current Password",
              style: TextStyle(
                fontSize: 14,
                color: CustomColors.textColorThree, // Text color
              ),
            ),
            SizedBox(height: 10),
            PasswordTextField(controller: currentpasswordController),
            SizedBox(height: 20),
            Text(
              "New Password",
              style: TextStyle(
                fontSize: 14,
                color: CustomColors.textColorThree,
              ),
            ),
            SizedBox(height: 10),
            PasswordTextField(controller: newpasswordController),
            SizedBox(height: 20),
            Text(
              "Re-enter New Password",
              style: TextStyle(
                fontSize: 14,
                color: CustomColors.textColorThree,
              ),
            ),
            SizedBox(height: 10),
            PasswordTextField(controller: reEnterpasswordController),
            Spacer(),
            Center(
              child: CustomButton(
                text: 'Change Password',
                onTap: () {},
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
