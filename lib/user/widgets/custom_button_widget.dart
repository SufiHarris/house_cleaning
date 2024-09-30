import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/custom_colors.dart';

// Controller for managing the button's pressed state
class ButtonController extends GetxController {
  var isPressed = false.obs;

  void pressButton() {
    isPressed.value = true;
    Future.delayed(Duration(milliseconds: 300), () {
      isPressed.value = false; // Reset to normal state after delay
    });
  }
}

// Reusable button widget
class CustomButton extends StatelessWidget {
  final String text;
  final Function onTap; // Callback for the button tap
  final double horizontalPadding;
  final double verticalPadding;
  final Icon? icon; // Optional icon parameter

  CustomButton({
    required this.text,
    required this.onTap,
    this.horizontalPadding = 100,
    this.verticalPadding = 15,
    this.icon,
  });

  final ButtonController buttonController = Get.put(ButtonController());

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        buttonController.pressButton(); // Manage button press state
        onTap(); // Trigger the onTap callback
      },
      child: Obx(
        () => AnimatedContainer(
          duration: Duration(
              milliseconds: 300), // Animation duration for smooth transition
          decoration: BoxDecoration(
            color: buttonController.isPressed.value
                ? CustomColors.textColorThree
                : Colors.white, // Background color changes smoothly
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: CustomColors.textColorThree,
              width: 1,
            ),
          ),
          padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: verticalPadding),
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 300), // Smooth text color change
              style: TextStyle(
                color: buttonController.isPressed.value
                    ? Colors.white
                    : CustomColors
                        .textColorThree, // Text color changes smoothly
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              child: Row(
                mainAxisSize: MainAxisSize
                    .min, // Ensure the row is as small as its content
                children: [
                  if (icon != null) icon!, // Show icon if it exists
                  Text(text), // Button text is customizable
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
