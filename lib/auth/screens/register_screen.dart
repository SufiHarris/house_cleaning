import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/custom_colors.dart';
import '../../user/screens/user_create_profile_screen.dart';
import '../widgets/image_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(_updateButtonState);
    passwordController.addListener(_updateButtonState);
    confirmPasswordController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Hello! Register to get started",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!GetUtils.isEmail(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const Image(
                        image: AssetImage("assets/images/eye.png"),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const Image(
                        image: AssetImage("assets/images/eye.png"),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
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
                  onPressed: _isButtonEnabled
                      ? () {
                          if (_formKey.currentState!.validate()) {
                            // Get.to(
                            //   () => CreateProfilePage(
                            //     email: emailController.text.trim(),
                            //     password: passwordController.text,
                            //   ),
                            // );
                          } else {
                            _showErrorSnackbar(
                                'Please correct the errors in the form.');
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    backgroundColor: _isButtonEnabled
                        ? CustomColors.primaryColor
                        : Colors.grey,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  child: const Text(
                    'Register',
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
                        "Or Register with",
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
                      onPressed: () {},
                    ),
                    ImageButton(
                      imageUrl: "assets/images/apple.svg",
                      onPressed: () {},
                    ),
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
      ),
    );
  }
}
