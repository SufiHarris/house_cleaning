import 'package:flutter/material.dart';
import '../../theme/custom_colors.dart';
import '../widgets/changepassword_widget.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: CustomColors.textColorThree),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Change Password',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: CustomColors.textColorThree,
                )),
        centerTitle: true,
      ),
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
            CustomPasswordField(),
            SizedBox(height: 20),
            Text(
              "New Password",
              style: TextStyle(
                fontSize: 14,
                color: CustomColors.textColorThree,
              ),
            ),
            SizedBox(height: 10),
            CustomPasswordField(),
            SizedBox(height: 20),
            Text(
              "Re-enter New Password",
              style: TextStyle(
                fontSize: 14,
                color: CustomColors.textColorThree,
              ),
            ),
            SizedBox(height: 10),
            CustomPasswordField(),
            Spacer(),
            Center(
              child: ChangePasswordButton(
                onPressed: () {
                  // Add functionality here
                },
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
