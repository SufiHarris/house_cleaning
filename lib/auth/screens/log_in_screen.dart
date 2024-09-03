import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/auth/widgets/image_button.dart';

import '../../theme/custom_colors.dart';

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Welcome back! Glad\nto see you, Again!",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                    hintText: 'Enter your password',
                    suffixIcon: IconButton(
                        onPressed: () {},
                        icon: const Image(
                            image: AssetImage("assets/images/eye.png")))),
              ),
              const SizedBox(
                height: 20,
              ),
              const Row(children: [
                Spacer(),
                Text(
                  "Forget Password?",
                  style: TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(106, 112, 124, 1),
                      fontWeight: FontWeight.bold),
                ),
              ]),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  Get.to(LogInScreen());
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
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1.0,
                        color: Colors.grey.withOpacity(0.2),
                        indent: 20.0,
                        endIndent: 10.0,
                      ),
                    ),
                    const Text(
                      "Or Login with",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1.0,
                        color: Colors.grey.withOpacity(0.2),
                        indent: 10.0,
                        endIndent: 20.0,
                      ),
                    ),
                  ],
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ImageButton(imageUrl: "assets/images/fb.svg"),
                  ImageButton(imageUrl: "assets/images/google.svg"),
                  ImageButton(imageUrl: "assets/images/apple.svg"),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "Don’t have an account? ",
                        style: TextStyle(
                            color: Colors.black, // Regular text color
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500),
                      ),
                      TextSpan(
                        text: "Register Now",
                        style: TextStyle(
                          color: CustomColors
                              .primaryColor, // Color for "Register Now"
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
