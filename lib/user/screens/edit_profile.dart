import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/provider/auth_provider.dart';
import '../../theme/custom_colors.dart';
import '../providers/user_provider.dart';
import '../widgets/custom_button_widget.dart';

class EditProfile extends StatelessWidget {
  EditProfile({super.key});

  final UserProvider userProfileController = Get.put(UserProvider());
  final AuthProvider authProvider = Get.find<AuthProvider>();

  void _showPhotoOptions(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          color: Colors.white, // Background color of the bottom sheet
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(16)), // Rounded corners
        ),
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.photo_library,
                  color: CustomColors.textColorThree), // Set icon color
              title: Text(
                'Choose from Gallery',
                style: TextStyle(
                    color: CustomColors.textColorThree), // Set text color
              ),
              onTap: () {
                userProfileController.pickImageFromGallery();
                Get.back(); // Close bottom sheet
              },
            ),
            Divider(), // Divider for better separation
            ListTile(
              leading: Icon(Icons.camera_alt,
                  color: CustomColors.textColorThree), // Set icon color
              title: Text(
                'Take a Photo',
                style: TextStyle(
                    color: CustomColors.textColorThree), // Set text color
              ),
              onTap: () {
                userProfileController.pickImageFromCamera();
                Get.back(); // Close bottom sheet
              },
            ),
          ],
        ),
      ),
      isScrollControlled: true, // Allow scrolling if needed
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Padding(
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
                      Obx(() {
                        return CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              userProfileController.profileImage.value != null
                                  ? FileImage(
                                      userProfileController.profileImage.value!)
                                  : const AssetImage(
                                          'assets/images/UserProfile-Pic.png')
                                      as ImageProvider,
                        );
                      }),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => _showPhotoOptions(context),
                          child: const CircleAvatar(
                            backgroundColor: Color(0xFF6B3F3A),
                            radius: 16,
                            child:
                                Icon(Icons.edit, size: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Jubayl Bin Meenak",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
              TextField(
                decoration: InputDecoration(
                  hintText: 'Saad Al Nayem',
                  labelStyle:
                      const TextStyle(color: Color(0xFFDCD7D8), fontSize: 16),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(color: Color(0xFFDCD7D8)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: CustomColors.textColorThree),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),
              SizedBox(height: 20),
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
                decoration: InputDecoration(
                  hintText: 'Enter phone number',
                  labelStyle:
                      const TextStyle(color: Color(0xFFDCD7D8), fontSize: 16),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(color: Color(0xFFDCD7D8)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: CustomColors.textColorThree),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
              SizedBox(height: 20),
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
                decoration: InputDecoration(
                  hintText: 'saadalnayem@gmail.com',
                  labelStyle:
                      const TextStyle(color: Color(0xFFDCD7D8), fontSize: 16),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(color: Color(0xFFDCD7D8)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: CustomColors.textColorThree),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),
              SizedBox(height: 80),
              Center(
                child: CustomButton(
                  text: 'Update',
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
