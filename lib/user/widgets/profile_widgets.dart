import 'package:flutter/material.dart';

import '../../theme/custom_colors.dart';

// Profile Header Widget
class ProfileHeader extends StatelessWidget {
  final String imagePath;
  final String name;

  const ProfileHeader({
    Key? key,
    required this.imagePath,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(imagePath),
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
          name,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: CustomColors.textColorThree,
              ),
        ),
      ],
    );
  }
}

// Profile TextField Widget
class ProfileTextField extends StatelessWidget {
  final String label;

  const ProfileTextField({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: CustomColors.eggPlant,
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        hintText: label,
        hintStyle: TextStyle(
          fontSize: 16,
          color: CustomColors.textColorThree,
        ),
      ),
    );
  }
}

// Profile PhoneField Widget
class ProfilePhoneField extends StatelessWidget {
  const ProfilePhoneField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 10),
        Expanded(
          child: TextField(
            readOnly: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: CustomColors.eggPlant,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              hintText: '123654789',
              hintStyle: TextStyle(
                fontSize: 16,
                // color: Color(0xFF6B3F3A),
                color: CustomColors.textColorThree,
              ),
              prefixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      '+1',
                      style: TextStyle(
                        fontSize: 16,
                        color: CustomColors.textColorThree,
                      ),
                    ),
                  ),
                  VerticalDivider(
                    color: CustomColors.textColorThree,
                    thickness: 1,
                    width: 1, // Minimal width for the divider
                    indent: 12, // Optional, add spacing to top and bottom
                    endIndent: 12,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Profile Button Widget
class ProfileButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final Color buttonColor;

  const ProfileButton({
    Key? key,
    required this.onPressed,
    required this.buttonText,
    this.buttonColor = const Color(0xFF6B3F3A),
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
        buttonText,
        style: TextStyle(
          color: buttonColor,
          // CustomColors.textColorThree, // Text color (matching the border)
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
