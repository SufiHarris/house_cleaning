import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/auth/provider/auth_provider.dart';
import '../../auth/model/usermodel.dart';
import '../../general_functions/user_profile_image.dart';
import '../../theme/custom_colors.dart';
// import '../../controllers/image_controller.dart';

class CreateProfilePage extends StatefulWidget {
  final String email;
  final String password;

  const CreateProfilePage(
      {super.key, required this.email, required this.password});

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
  final TextEditingController passwordController =
      TextEditingController(); // Add this line

  final AuthProvider authProvider = Get.find<AuthProvider>();
  final ImageController imageController = Get.put(ImageController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Assign the email and password to their respective controllers
    emailController.text = widget.email; // Assigning the email
    passwordController.text = widget.password; // Assigning the password
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Show options to pick an image from gallery or take a new one using the camera
  void _showPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pick from Gallery'),
              onTap: () {
                Get.back(); // Close the modal
                imageController.pickImageFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () {
                Get.back(); // Close the modal
                imageController.pickImageFromCamera();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      onTap: () {
                        if (nameController.text.isEmpty ||
                            phoneController.text.isEmpty) {
                          Get.snackbar(
                              'Error', 'Please enter all required details.');
                          return;
                        }

                        setState(() {
                          isNextPressed = true; // Set button as pressed
                        });

                        // Navigate to the address details tab
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
                  SizedBox(height: 20),
                  TextField(
                    controller: locationController,
                    decoration: InputDecoration(
                      hintText: 'Location',
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
                    controller: buildingController,
                    decoration: InputDecoration(
                      hintText: 'Building Name',
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
                    controller: floorController,
                    decoration: InputDecoration(
                      hintText: 'Floor',
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
                    controller: landmarkController,
                    decoration: InputDecoration(
                      hintText: 'Landmark',
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
                  SizedBox(height: 40), // Space before the save button
                  Center(
                    child: InkWell(
                      onTap: () {
                        // Check if all fields are filled
                        if (nameController.text.isNotEmpty &&
                            emailController.text.isNotEmpty &&
                            phoneController.text.isNotEmpty &&
                            passwordController.text.isNotEmpty &&
                            locationController
                                .text.isNotEmpty && // Check location
                            buildingController
                                .text.isNotEmpty && // Check building
                            floorController.text.isNotEmpty && // Check floor
                            landmarkController.text.isNotEmpty) {
                          // Check landmark

                          // Create the address model from the collected data
                          AddressModel address = AddressModel(
                            location: locationController.text,
                            building: buildingController.text,
                            floor: int.parse(
                                floorController.text), // Convert floor to int
                            landmark: landmarkController.text,
                            geolocation: GeoLocationModel(
                              lat: '0.0', // Dummy latitude value for now
                              lon: '0.0', // Dummy longitude value for now
                            ), // Pass a GeoLocationModel, not an empty list
                          );

                          // Call the save profile method
                          _saveProfile(
                            name: nameController.text,
                            email: emailController.text,
                            phone: phoneController.text,
                            password: passwordController.text,
                            image:
                                '', // Handle image as per your implementation
                            addresses: [address], // Pass the address model
                          );
                        } else {
                          // Handle the case where inputs are empty
                          Get.snackbar(
                              "Error", "Please fill in all required fields.",
                              snackPosition: SnackPosition.BOTTOM);
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: CustomColors.textColorThree,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                        child: Center(
                          child: Text(
                            "Save Changes",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
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

  void _saveProfile({
    String? name,
    String? email,
    String? phone,
    String? password,
    String? image,
    List<AddressModel> addresses = const [],
  }) async {
    // Create the UserModel instance
    UserModel user = UserModel(
      name: name ?? '', // Assign empty string if null
      email: email ?? '',
      image: image ?? '',
      password: password ?? '',
      address: addresses,
      phone: phone ?? '',
      userId: '', // Set to empty initially, will be updated after user creation
    );

    // Call the saveUserProfile method in AuthProvider
    await authProvider.saveUserProfile(user);
  }
}
