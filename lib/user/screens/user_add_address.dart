import 'package:flutter/material.dart';
import '../../theme/custom_colors.dart';
import '../widgets/custom_button_widget.dart';

class UserAddAddressPage extends StatelessWidget {
  UserAddAddressPage({super.key});
  bool isNextPressed = false;

  final TextEditingController locationController = TextEditingController();
  final TextEditingController buildingController = TextEditingController();
  final TextEditingController floorController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Address"), // Customize as needed
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
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
                  padding: EdgeInsets.symmetric(horizontal: 75, vertical: 12),
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
              SizedBox(height: 15),
              Text("Floor",
                  style: TextStyle(
                      color: CustomColors.textColorThree, fontSize: 16)),
              SizedBox(height: 8),
              TextField(
                controller: floorController,
                decoration: InputDecoration(
                  hintText: 'Enter your floor',
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
              SizedBox(height: 15),
              Text("Landmark",
                  style: TextStyle(
                      color: CustomColors.textColorThree, fontSize: 16)),
              SizedBox(height: 8),
              TextField(
                controller: landmarkController,
                decoration: InputDecoration(
                  hintText: 'Enter landmark',
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
              SizedBox(height: 100),
              Center(
                child: CustomButton(
                  text: 'Save Address',
                  onTap: () {
                    // Save address logic here
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
