import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/provider/auth_provider.dart';
import '../../generated/l10n.dart';
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
      appBar: AppBar(title: Text(S.of(context).changePassword)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50), // Space from top
            Text(
              S.of(context).currentPassword,
              style: TextStyle(
                fontSize: 14,
                color: CustomColors.textColorThree, // Text color
              ),
            ),
            SizedBox(height: 10),
            PasswordTextField(controller: currentpasswordController),
            SizedBox(height: 20),
            Text(
              S.of(context).newPassword,
              style: TextStyle(
                fontSize: 14,
                color: CustomColors.textColorThree,
              ),
            ),
            SizedBox(height: 10),
            PasswordTextField(controller: newpasswordController),
            SizedBox(height: 20),
            Text(
              S.of(context).reEnterNewPassword,
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
                text: S.of(context).changePassword,
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
