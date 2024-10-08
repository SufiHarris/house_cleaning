import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:house_cleaning/user/screens/user_googlemap.dart';
import '../../theme/custom_colors.dart';
import '../widgets/custom_button_widget.dart';
import 'controller/user_addaddress_controller.dart';

class UserAddAddressPage extends StatelessWidget {
  UserAddAddressPage({super.key});
  final AddAddressController addAddressController =
      Get.put(AddAddressController());
  bool isNextPressed = false;

  final TextEditingController locationController = TextEditingController();
  final TextEditingController buildingController = TextEditingController();
  final TextEditingController floorController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();

  final RxBool isAllFieldsFilled = false.obs;

  void checkFields() {
    isAllFieldsFilled.value =
        addAddressController.locationController.text.isNotEmpty &&
            addAddressController.buildingController.text.isNotEmpty &&
            addAddressController.floorController.text.isNotEmpty &&
            addAddressController.landmarkController.text.isNotEmpty;
  }

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
                controller: addAddressController.locationController,
                onChanged: (_) => checkFields(),
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
                onPressed: () async {
                  LatLng selectedLocation =
                      await Get.to(() => SelectLocationOnMapPage());
                  if (selectedLocation != null) {
                    await addAddressController
                        .setLocationFromMap(selectedLocation);
                  }
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
                controller: addAddressController.buildingController,
                onChanged: (_) => checkFields(),
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
                controller: addAddressController.floorController,
                onChanged: (_) => checkFields(),
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
                controller: addAddressController.landmarkController,
                onChanged: (_) => checkFields(),
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
              Obx(() => ElevatedButton(
                    onPressed: isAllFieldsFilled.value
                        ? () async {
                            await addAddressController.saveAddress();
                            Get.back();
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 120, vertical: 15),
                      backgroundColor: isAllFieldsFilled.value
                          ? CustomColors.textColorThree
                          : Colors.white,
                      side: BorderSide(color: CustomColors.textColorThree),
                    ),
                    child: Text(
                      'Save Address',
                      style: TextStyle(
                        color: isAllFieldsFilled.value
                            ? Colors.white
                            : CustomColors.textColorThree,
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
