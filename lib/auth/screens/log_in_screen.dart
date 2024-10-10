import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/auth/screens/register_screen.dart';
import 'package:house_cleaning/auth/widgets/image_button.dart';
import 'package:house_cleaning/auth/provider/auth_provider.dart';

import '../../theme/custom_colors.dart';
import '../../user/screens/user_home.dart';

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Get.find<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Welcome back!\nGlad to see you, Again!",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: authProvider.emailController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your email',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: authProvider.passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: 'Enter your password',
                        suffixIcon: IconButton(
                            onPressed: () {},
                            icon: const Image(
                                image: AssetImage("assets/images/eye.png")))),
                  ),
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      await authProvider.signIn();
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ImageButton(
                        imageUrl: "assets/images/fb.svg",
                        onPressed: () {},
                      ),
                      ImageButton(
                        imageUrl: "assets/images/google.svg",
                        onPressed: () {
                          //authProvider.initiateGoogleSignIn();
                        },
                      ),
                      ImageButton(
                        imageUrl: "assets/images/apple.svg",
                        onPressed: () {
                          // authProvider.signInWithApple();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500),
                          ),
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.to(const RegisterScreen());
                              },
                            text: "Register Now",
                            style: TextStyle(
                              color: CustomColors.primaryColor,
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
          Obx(() {
            if (authProvider.isLoading.value) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.3),
                    ],
                  ),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    color: CustomColors.primaryColor,
                  ),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
        ],
      ),
    );
  }
}
