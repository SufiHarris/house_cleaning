import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/employee/provider/employee_provider.dart';
import 'package:house_cleaning/general_functions/user_profile_image.dart';
// Import ImageController

class AddEmployeeScreen extends StatelessWidget {
  AddEmployeeScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  // Controllers to capture form data
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emergencyPhoneController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final employeeProvider = Get.put(EmployeeProvider());
    final imageController =
        Get.put(ImageController()); // Initialize ImageController

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Employee"),
        backgroundColor: Colors.grey[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey,
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            // Open image picker from camera or gallery
                            imageController
                                .pickImageFromGallery(); // Choose Gallery for now
                          },
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.brown,
                            child: Icon(
                              Icons.camera_alt,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                buildTextField("Full Name", "Ex. Jacob Milan", _nameController),
                buildTextField(
                    "Email", "Ex. jacob@gmail.com", _emailController),
                buildTextField("Phone Number", "+1 ", _phoneController,
                    TextInputType.phone),
                buildTextField("Role", "Ex. Manager, Staff", _roleController),
                buildTextField(
                    "Age", "Ex. 30", _ageController, TextInputType.number),
                buildTextField("Emergency Phone", "+1 ",
                    _emergencyPhoneController, TextInputType.phone),
                buildTextField(
                    "Password", "Do not share password", _passwordController),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Handle Cancel action
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.brown,
                        side: const BorderSide(color: Colors.brown),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                      ),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String imageUrl = imageController.image != null
                              ? await imageController
                                  .uploadImageToFirebase(imageController.image!)
                              : "";

                          // Call addStaff method and pass form data
                          employeeProvider.addStaff(
                            _nameController.text,
                            _emailController.text,
                            int.parse(_phoneController.text),
                            _passwordController.text,
                            _roleController.text,
                            int.parse(_ageController.text),
                            int.parse(_emergencyPhoneController.text),
                            imageUrl, // Pass the uploaded image URL
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                      ),
                      child: const Text("Save changes"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    String label,
    String hintText,
    TextEditingController controller, [
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  ]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          validator: (value) => value!.isEmpty ? "Please enter $label" : null,
        ),
      ],
    );
  }
}
