import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../auth/provider/auth_provider.dart';
import '../../theme/custom_colors.dart';
import '../providers/user_provider.dart';

class CreateProfilePage extends StatefulWidget {
  final GoogleSignInAccount account;

  const CreateProfilePage({super.key, required this.account});
  @override
  _CreateProfilePageState createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isNextPressed = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController buildingController = TextEditingController();
  final TextEditingController floorController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();

  final UserProvider userProfileController = Get.put(UserProvider());
  final AuthProvider authProvider = Get.find<AuthProvider>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showPhotoOptions(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: const BoxDecoration(
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
    final AuthProvider authProvider = Get.find<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Profile"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: TabBar(
            controller: _tabController,
            indicatorColor: CustomColors.textColorThree,
            indicatorWeight: 2,
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: CustomColors.textColorThree,
            unselectedLabelColor: Color(0xFFDCD7D8),
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: 'Personal Details'),
              Tab(text: 'Address Details'),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Personal Details Tab
          SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                          width: 16), // Space between avatar and text fields
                      Expanded(
                        child: Stack(
                          // alignment: Alignment.bottomLeft,
                          children: [
                            Obx(() {
                              return CircleAvatar(
                                radius: 70,
                                backgroundImage: userProfileController
                                            .profileImage.value !=
                                        null
                                    ? FileImage(userProfileController
                                        .profileImage.value!)
                                    : const AssetImage(
                                            'assets/images/UserProfile-Pic.png')
                                        as ImageProvider,
                              );
                            }),
                            Positioned(
                              bottom: 0,
                              right: 200,
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
                      ),
                    ],
                  ),

                  SizedBox(height: 20),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter your name',
                      labelStyle: const TextStyle(
                          color: Color(0xFFDCD7D8), fontSize: 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(color: Color(0xFFDCD7D8)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide:
                            BorderSide(color: CustomColors.textColorThree),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      hintText: 'Enter phone number',
                      labelStyle: const TextStyle(
                          color: Color(0xFFDCD7D8), fontSize: 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(color: Color(0xFFDCD7D8)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide:
                            BorderSide(color: CustomColors.textColorThree),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      prefixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
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
                            indent:
                                12, // Optional, add spacing to top and bottom
                            endIndent: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 300), // Added spacing before button
                  Center(
                    child: InkWell(
                      onTap: () async {
                        if (nameController.text.isEmpty ||
                            phoneController.text.isEmpty) {
                          Get.snackbar(
                              'Error', 'Please enter all required details.');
                          return;
                        }

                        // Simulate generating a random password if not provided (for Google sign-in)
                        String randomPassword =
                            "123456"; // Can be replaced with a generated password

                        await authProvider.saveUserProfile(
                          email: widget.account.email,
                          name: nameController
                              .text, // Collect name from user input
                          phone: phoneController.text,
                          password:
                              randomPassword, // Use the generated or provided password
                          address: {
                            'Building': 'DemoBuild', // Dummy building name
                            'Floor': 2, // Dummy floor number
                            'Geolocation': [
                              10,
                              12
                            ], // Dummy geolocation (latitude, longitude)
                            'Landmark': 'Soura', // Dummy landmark
                            'Location':
                                'soura market', // Dummy location description
                          },
                        );

                        setState(() {
                          isNextPressed = true; // Set button as pressed
                        });
                        _tabController.animateTo(1); // Switch to next tab

                        Future.delayed(Duration(milliseconds: 300), () {
                          setState(() {
                            isNextPressed =
                                false; // Reset button state after delay
                          });
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: isNextPressed
                              ? CustomColors.textColorThree
                              : Colors
                                  .white, // Background color changes smoothly
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: CustomColors.textColorThree,
                            width: 1,
                          ),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: Duration(milliseconds: 300),
                            style: TextStyle(
                              color: isNextPressed
                                  ? Colors.white
                                  : CustomColors.textColorThree,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            child: Text("Next"),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Address Details Tab
          SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Enter Location",
                      style: TextStyle(
                          color: CustomColors.textColorThree, fontSize: 16)),
                  SizedBox(height: 8),
                  TextField(
                    controller: locationController,
                    decoration: InputDecoration(
                      hintText: 'Enter location',
                      labelStyle: const TextStyle(
                          color: Color(0xFFDCD7D8), fontSize: 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(color: Color(0xFFDCD7D8)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide:
                            BorderSide(color: CustomColors.textColorThree),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                    ),
                  ),
                  SizedBox(height: 15),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Add location fetch logic
                    },
                    icon: Icon(Icons.location_pin,
                        color: CustomColors.textColorThree),
                    label: Text("Use Current Location",
                        style: TextStyle(color: CustomColors.textColorThree)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: BorderSide(color: CustomColors.textColorThree),
                      ),
                      elevation: 0,
                      padding:
                          EdgeInsets.symmetric(horizontal: 75, vertical: 12),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text("Building Number",
                      style: TextStyle(
                          color: CustomColors.textColorThree, fontSize: 16)),
                  SizedBox(height: 8),
                  TextField(
                    controller: buildingController,
                    decoration: InputDecoration(
                      hintText: 'Enter building number',
                      labelStyle: const TextStyle(
                          color: Color(0xFFDCD7D8), fontSize: 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(color: Color(0xFFDCD7D8)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide:
                            BorderSide(color: CustomColors.textColorThree),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text("Floor",
                      style: TextStyle(
                          color: CustomColors.textColorThree, fontSize: 16)),
                  SizedBox(height: 8),
                  TextField(
                    controller: floorController,
                    decoration: InputDecoration(
                      hintText: 'Enter your floor',
                      labelStyle: const TextStyle(
                          color: Color(0xFFDCD7D8), fontSize: 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(color: Color(0xFFDCD7D8)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide:
                            BorderSide(color: CustomColors.textColorThree),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text("Landmark",
                      style: TextStyle(
                          color: CustomColors.textColorThree, fontSize: 16)),
                  SizedBox(height: 8),
                  TextField(
                    controller: landmarkController,
                    decoration: InputDecoration(
                      hintText: 'Enter landmark',
                      labelStyle: const TextStyle(
                          color: Color(0xFFDCD7D8), fontSize: 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(color: Color(0xFFDCD7D8)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide:
                            BorderSide(color: CustomColors.textColorThree),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                    ),
                  ),
                  SizedBox(height: 100),
                  Center(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isNextPressed = true; // Set button as pressed
                        });

                        // Add logic for what happens when the button is pressed here.

                        Future.delayed(Duration(milliseconds: 300), () {
                          // Reset button state after 250 milliseconds
                          setState(() {
                            isNextPressed = false; // Reset to normal state
                          });
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(
                            milliseconds:
                                300), // Animation duration for smooth transition
                        decoration: BoxDecoration(
                          color: isNextPressed
                              ? CustomColors.textColorThree
                              : Colors
                                  .white, // Background color changes smoothly
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: CustomColors.textColorThree,
                            width: 1,
                          ),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: Duration(
                                milliseconds: 300), // Smooth text color change
                            style: TextStyle(
                              color: isNextPressed
                                  ? Colors.white
                                  : CustomColors
                                      .textColorThree, // Text color changes smoothly
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            child: Text("Save Changes"),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
