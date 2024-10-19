import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/employee/provider/employee_provider.dart';
import 'package:house_cleaning/auth/model/staff_model.dart';
import 'package:house_cleaning/general_functions/user_profile_image.dart';

class EditEmployeeScreen extends StatelessWidget {
  final StaffModel employee; // This will receive the employee data

  EditEmployeeScreen({required this.employee, super.key});

  final _formKey = GlobalKey<FormState>();

  // Controllers to capture form data, initialized with the employee data
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
    final imageController = Get.put(ImageController());

    // Reset the image in ImageController when navigating to the screen
    imageController.image =
        null; // or you can directly call imageController.update()

    // Pre-fill the form with the employee data
    _nameController.text = employee.name;
    _emailController.text = employee.email;
    _phoneController.text = employee.phoneNumber.toString();
    _roleController.text = employee.role;
    _ageController.text = employee.age.toString();
    _emergencyPhoneController.text = employee.emergencyPhoneNumber.toString();
    _passwordController.text = employee.password;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Employee"),
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
                      GetBuilder<ImageController>(
                        builder: (controller) {
                          return CircleAvatar(
                            radius: 50,
                            backgroundImage: controller.image != null
                                ? FileImage(controller.image!)
                                : NetworkImage(employee.image)
                                    as ImageProvider, // Show employee image if no new image is picked
                            backgroundColor: Colors.grey,
                            child: controller.image == null ? null : null,
                          );
                        },
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            imageController
                                .pickImageFromGallery(); // Pick image from gallery
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
                      onPressed: () async {
                        employeeProvider.deleteStaff(employee.employeeId);
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                      ),
                      child: const Text("Delete Employee"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String imageUrl = imageController.image != null
                              ? await imageController
                                  .uploadImageToFirebase(imageController.image!)
                              : employee
                                  .image; // Use existing image if no new image is picked

                          employeeProvider.updateStaff(
                            employee.employeeId,
                            {
                              'name': _nameController.text,
                              'email': _emailController.text,
                              'phone_number': int.parse(_phoneController.text),
                              'password': _passwordController.text,
                              'role': _roleController.text,
                              'age': int.parse(_ageController.text),
                              'emergency_phn_number':
                                  int.parse(_emergencyPhoneController.text),
                              'image': imageUrl,
                            },
                          );
                          Get.back();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                      ),
                      child: const Text("Edit changes"),
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
