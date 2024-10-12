import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/auth/screens/register_screen.dart';
import 'package:house_cleaning/auth/widgets/image_button.dart';
import 'package:house_cleaning/auth/provider/auth_provider.dart';

import '../../theme/custom_colors.dart';
import '../../user/screens/user_home.dart';

class FastRegister extends StatelessWidget {
  const FastRegister({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController nameController = TextEditingController();
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
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your name',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: emailController,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: 'Enter your email',
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
                      await authProvider.staffSignIn();
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
                  const SizedBox(height: 50),
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
