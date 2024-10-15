import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/auth/model/usermodel.dart';
import 'package:house_cleaning/auth/provider/auth_provider.dart';
import 'package:house_cleaning/user/providers/user_provider.dart'; // Import UserProvider
import '../../theme/custom_colors.dart';

class FastRegister extends StatelessWidget {
  final bool isCartAction; // New flag to differentiate between actions

  const FastRegister({super.key, required this.isCartAction});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    final AuthProvider authProvider = Get.find<AuthProvider>();
    final UserProvider userProvider =
        Get.find<UserProvider>(); // Get the UserProvider

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
                    decoration: const InputDecoration(
                      hintText: 'Enter your email',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    obscureText: true, // Mark this as password field
                    decoration: InputDecoration(
                      hintText: 'Enter your password', // Update hint text
                      suffixIcon: IconButton(
                        onPressed: () {
                          // Implement password visibility toggle if needed
                        },
                        icon: const Image(
                          image: AssetImage("assets/images/eye.png"),
                        ),
                      ),
                    ),
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
                      // Fetch user details from local storage
                      UserModel? existingUser = await getUserDetailsFromLocal();
                      List<AddressModel> addressList = [];

                      // Add the selected address from the UserProvider
                      if (userProvider.selectedAddress.value != null) {
                        addressList.add(userProvider.selectedAddress.value!);
                      }

                      // Create a UserModel instance with the collected data
                      final user = UserModel(
                        name: nameController.text.isNotEmpty
                            ? nameController.text
                            : existingUser?.name ??
                                '', // Use existing name if empty
                        email: emailController.text.isNotEmpty
                            ? emailController.text
                            : existingUser?.email ??
                                '', // Use existing email if empty
                        image: existingUser?.image ??
                            '', // Use existing image or default
                        password: passwordController
                            .text, // Use the new password input
                        address:
                            addressList, // Use the selected address from UserProvider
                        phone: existingUser?.phone ??
                            '', // Use existing phone or default
                        userId: existingUser?.userId ??
                            '', // Use existing userId or default
                      );

                      // Pass the flag to the save method
                      await authProvider.saveUserProfileForGuest(
                          user, isCartAction);
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
