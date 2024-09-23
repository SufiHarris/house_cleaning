import 'package:flutter/material.dart';

import '../../theme/custom_colors.dart';

class CustomPasswordField extends StatelessWidget {
  const CustomPasswordField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: true, // For password input
      decoration: InputDecoration(
        filled: true,
        fillColor: CustomColors.eggPlant, // Light background
        contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: CustomColors.textColorThree, width: 1),
          borderRadius: BorderRadius.circular(30), // Rounded edges
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: CustomColors.textColorThree, width: 1),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}

// Profile Button Widget
class ChangePasswordButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ChangePasswordButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: CustomColors
              .textColorThree, // Border color (matching the text color in the design)
          width: 0.5, // Border thickness
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Rounded corners
        ),
        padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
      ),
      child: Text(
        "Change Password",
        style: TextStyle(
          color:
              CustomColors.textColorThree, // Text color (matching the border)
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
