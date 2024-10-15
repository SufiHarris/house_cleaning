import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../general_functions/user_profile_image.dart';
import '../../theme/custom_colors.dart';
import '../widgets/custom_button_widget.dart';
import '../../auth/model/usermodel.dart';

class EditProfile extends StatefulWidget {
  EditProfile({Key? key}) : super(key: key);
  final ImageController imageController = Get.put(ImageController());

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  // TextEditingControllers for the form fields
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  // File? _image;

  bool isLoading = true; // To show a loading indicator while fetching data

  @override
  void initState() {
    super.initState();
    loadUserData(); // Fetch user data when the screen initializes
  }

  // Method to load user data from SharedPreferences
  Future<void> loadUserData() async {
    UserModel? user = await getUserDetailsFromLocal();
    if (user != null) {
      print(
          "Fetched User: Name - ${user.name}, Email - ${user.email}, Phone - ${user.phone}");
      print("user id ${user.userId}");
      setState(() {
        nameController.text = user.name;
        emailController.text = user.email;
        phoneController.text =
            user.phone; // Assuming phone number is saved as location
        isLoading = false;
      });
    } else {
      print("User is null. Cannot load data.");
      setState(() {
        isLoading = false;
      });
      Get.snackbar("Error", "Failed to load user data.");
    }
  }

  // Method to update user details both locally and in Firestore
  Future<void> updateUserDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userDetails = prefs.getString('userDetails');
      String? userDocId =
          prefs.getString('userDocId'); // Retrieve the document ID

      print("UserId Update: $userDocId");

      if (userDetails != null && userDocId != null) {
        Map<String, dynamic> userMap = jsonDecode(userDetails);

        // Get the old email for comparison
        String oldEmail = userMap['email'];

        // Update the model with new values from text fields or keep existing values
        UserModel updatedUser = UserModel(
          name: nameController.text.isNotEmpty
              ? nameController.text
              : userMap['name'],
          email: emailController.text.isNotEmpty
              ? emailController.text
              : userMap['email'],
          phone: phoneController.text.isNotEmpty
              ? phoneController.text
              : userMap['phone'],
          image: userMap['image'] ?? '',
          password: userMap['password'] ?? '',
          address: userMap['address'] != null
              ? List<AddressModel>.from((userMap['address'] as List)
                  .map((item) => AddressModel.fromFirestore(item)))
              : [],
          userId: userDocId,
        );

        // Update the SharedPreferences with the new values
        String updatedUserJson = jsonEncode(updatedUser.toMap());
        await prefs.setString('userDetails', updatedUserJson);

        // Update Firestore using the document ID
        await FirebaseFirestore.instance
            .collection('users_table')
            .doc(userDocId)
            .update(updatedUser.toMap());

        // Check if the email has changed
        if (oldEmail != updatedUser.email) {
          // Get the current user
          User? currentUser = FirebaseAuth.instance.currentUser;

          // Check if the current user's UID matches the userDocId
          if (currentUser != null && currentUser.uid == userDocId) {
            // Update the email in Firebase Authentication
            await currentUser.updateEmail(updatedUser.email).then((_) {
              print("Email updated in Auth table successfully.");
            }).catchError((e) {
              print("Failed to update email in Auth table: $e");
              Get.snackbar("Error", "Failed to update email in Auth table.",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.redAccent,
                  colorText: Colors.white,
                  duration: Duration(seconds: 3));
            });
          } else {
            print("User not found or UID does not match.");
            Get.snackbar("Error", "User not found or UID does not match.",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.redAccent,
                colorText: Colors.white,
                duration: Duration(seconds: 3));
          }
        }

        Get.snackbar("Success", "Profile updated successfully!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: Duration(seconds: 3));
      } else {
        Get.snackbar("Error", "No user data found!");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to update profile. Please try again.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          duration: Duration(seconds: 3));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: isLoading
          ? Center(
              child:
                  CircularProgressIndicator()) // Show loader while fetching data
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            GetBuilder<ImageController>(
                              builder: (controller) {
                                return CircleAvatar(
                                  radius: 60,
                                  backgroundImage: controller.image != null
                                      ? FileImage(controller.image!)
                                      : const AssetImage(
                                              'assets/images/UserProfile-Pic.png')
                                          as ImageProvider,
                                );
                              },
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () => _showPhotoOptions(context),
                                child: const CircleAvatar(
                                  backgroundColor: Color(0xFF6B3F3A),
                                  radius: 16,
                                  child: Icon(Icons.edit,
                                      size: 18, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Edit Profile",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: CustomColors.textColorThree,
                                  ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Personal details',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF6B3F3A),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Name Field
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                              const BorderSide(color: Color(0xFFDCD7D8)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                              BorderSide(color: CustomColors.textColorThree),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Phone Number Field
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Phone Number',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF6B3F3A),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                              const BorderSide(color: Color(0xFFDCD7D8)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                              BorderSide(color: CustomColors.textColorThree),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 20),
                    // Email Field
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF6B3F3A),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                              const BorderSide(color: Color(0xFFDCD7D8)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                              BorderSide(color: CustomColors.textColorThree),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 80),
                    Center(
                      child: CustomButton(
                        text: 'Update',
                        onTap: updateUserDetails,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _showPhotoOptions(BuildContext context) {
    final ImageController imageController = Get.put(ImageController());
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(16)), // Rounded corners
        ),
        child: Wrap(
          children: [
            ListTile(
              leading:
                  Icon(Icons.photo_library, color: CustomColors.textColorThree),
              title: Text(
                'Choose from Gallery',
                style: TextStyle(color: CustomColors.textColorThree),
              ),
              onTap: () {
                // Implement your image picking logic here
                // For example:
                imageController.pickImageFromGallery();
                Get.back(); // Close bottom sheet
              },
            ),
            Divider(), // Divider for better separation
            ListTile(
              leading:
                  Icon(Icons.camera_alt, color: CustomColors.textColorThree),
              title: Text(
                'Take a Photo',
                style: TextStyle(color: CustomColors.textColorThree),
              ),
              onTap: () {
                imageController.pickImageFromGallery();
                Get.back();
              },
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
