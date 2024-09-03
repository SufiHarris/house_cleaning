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
          const Image(
            image: AssetImage("assets/images/auth_screen_bg.png"),
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(
                    flex: 1,
                  ),
                  const Text(
                    "Services\nthat feel clean",
                    style: TextStyle(
                      fontSize: 63,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Spacer(
                    flex: 8,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(const LogInScreen());
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      backgroundColor: CustomColors.primaryColor,
                      elevation: 0,
                      // padding: const EdgeInsets.symmetric(
                      //   horizontal: 40,
                      //   vertical: 15,
                      // ),
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

                        // padding: const EdgeInsets.symmetric(
                        //   horizontal: 40,
                        //   vertical: 15,
                        // ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                            side: const BorderSide(color: Colors.black)),
                      ),
                      child: const Text(
                        'Register',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Text("Continue as guest",
                      style: TextStyle(
                        color: CustomColors.primaryColor,
                      )),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
