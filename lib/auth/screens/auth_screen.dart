import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:house_cleaning/auth/screens/log_in_screen.dart';
import 'package:house_cleaning/auth/screens/register_screen.dart';
import 'package:house_cleaning/theme/custom_colors.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            "assets/images/auth_screen_bg.png", // Replace with your image path
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Column(
            children: [
              // Top Section with Curved Container
              Stack(
                children: [
                  ClipPath(
                    clipper: BottomWaveClipper(), // Use the custom clipper here
                    child: Container(
                      height: 150,
                      color: CustomColors.primaryColor,
                    ),
                  ),
                  // Positioned logo that overlaps the curved container
                  Positioned(
                    top:
                        70, // Adjust this value to control how much the logo overlaps
                    left: MediaQuery.of(context).size.width / 2 -
                        50, // Center the logo horizontally
                    child: Image.asset(
                      "assets/images/logo.png", // Replace with your logo image path
                      height: 100, // Adjust logo size as needed
                    ),
                  ),
                ],
              ),
              // const SizedBox(
              //     height: 50), // Add space between the logo and the text
              Column(
                children: [
                  Text(
                    "room services",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color:
                          CustomColors.primaryColor, // Adjust color as needed
                    ),
                  ),
                ],
              ),
              Text(
                "Providing services that feel clean",
                style: TextStyle(
                  fontSize: 16,
                  color: CustomColors.primaryColor, // Adjust color as needed
                ),
              ),
              const Spacer(flex: 10),
              // Buttons Section
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Get.to(const LogInScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        backgroundColor: CustomColors.primaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(const RegisterScreen());
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 56),
                          backgroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                            side: BorderSide(color: CustomColors.primaryColor),
                          ),
                        ),
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    // const SizedBox(height: 20),
                    Text(
                      "Continue as guest",
                      style: TextStyle(
                        color: CustomColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Custom Clipper Class for the Curve
class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstControlPoint = Offset(size.width / 2, size.height);
    var firstEndPoint = Offset(size.width, size.height - 50);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
