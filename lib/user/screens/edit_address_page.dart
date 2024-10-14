import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:house_cleaning/auth/model/usermodel.dart'; // Import the AddressModel
import 'package:house_cleaning/user/screens/user_googlemap.dart';
import 'package:house_cleaning/user/screens/user_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/custom_colors.dart';
import '../widgets/custom_button_widget.dart';
import 'controller/user_addaddress_controller.dart';

class EditAddressPage extends StatelessWidget {
  EditAddressPage({super.key});

  // Retrieve the passed AddressModel and userId using Get.arguments
  final Map<String, dynamic> args = Get.arguments;
  late final AddressModel addressModel = args['address'];
  late final String userId;

  final AddAddressController addAddressController =
      Get.put(AddAddressController());

  final RxBool isAllFieldsFilled = false.obs;

  // Pre-fill the controllers with existing data
  void initTextControllers() {
    addAddressController.locationController.text = addressModel.location;
    addAddressController.buildingController.text = addressModel.building;
    addAddressController.floorController.text = addressModel.floor.toString();
    addAddressController.landmarkController.text = addressModel.landmark;
    // You could also initialize geolocation if needed
  }

  void checkFields() {
    isAllFieldsFilled.value =
        addAddressController.locationController.text.isNotEmpty &&
            addAddressController.buildingController.text.isNotEmpty &&
            int.tryParse(addAddressController.floorController.text) !=
                null && // Validate that it's a number
            addAddressController.landmarkController.text.isNotEmpty;

    print("All fields filled: ${isAllFieldsFilled.value}"); // Add this line
  }

  Future<void> updateAddress() async {
    try {
      // Get user ID from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userDocId');

      if (userId == null) {
        Get.snackbar("Error", "User ID not found.");
        return;
      }

      // Compare the current values with the updated values
      Map<String, dynamic> updatedFields = {};

      // Check each field for changes, only update if different
      if (addAddressController.locationController.text !=
          addressModel.location) {
        updatedFields['Location'] =
            addAddressController.locationController.text;
      }
      if (addAddressController.buildingController.text !=
          addressModel.building) {
        updatedFields['Building'] =
            addAddressController.buildingController.text;
      }
      if (int.parse(addAddressController.floorController.text) !=
          addressModel.floor) {
        updatedFields['Floor'] =
            int.parse(addAddressController.floorController.text);
      }
      if (addAddressController.landmarkController.text !=
          addressModel.landmark) {
        updatedFields['Landmark'] =
            addAddressController.landmarkController.text;
      }

      if (updatedFields.isEmpty) {
        Get.snackbar("No Changes", "No fields were changed.");
        return;
      }

      // Retrieve user's document from Firestore
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users_table').doc(userId);
      DocumentSnapshot userDocSnapshot = await userDocRef.get();

      if (userDocSnapshot.exists) {
        // Fetch the current address list and fix the casting issue
        List<dynamic> addressList =
            (userDocSnapshot.data() as Map<String, dynamic>)['address'] ?? [];

        // Find the index of the address to update
        int indexToUpdate = -1;
        for (int i = 0; i < addressList.length; i++) {
          var item = addressList[i];
          if (item['Building'] == addressModel.building &&
              item['Geolocation'][0].toString() ==
                  addressModel.geolocation.lat &&
              item['Geolocation'][1].toString() ==
                  addressModel.geolocation.lon) {
            indexToUpdate = i;
            break;
          }
        }

        if (indexToUpdate == -1) {
          Get.snackbar("Error", "Address not found in Firestore.");
          return;
        }

        // Update the specific address with the new fields
        addressList[indexToUpdate] = {
          ...addressList[indexToUpdate],
          ...updatedFields, // Merge the updated fields
        };

        // Update Firestore with the new address list
        await userDocRef.update({'address': addressList});

        // Update SharedPreferences as well
        String? userDetailsJson = prefs.getString('userDetails');
        if (userDetailsJson != null) {
          Map<String, dynamic> userMap = jsonDecode(userDetailsJson);

          // Update the local user address in SharedPreferences
          List<dynamic> localAddresses = userMap['address'] ?? [];
          localAddresses[indexToUpdate] = {
            ...localAddresses[indexToUpdate],
            ...updatedFields,
          };

          // Save the updated user details back to SharedPreferences
          userMap['address'] = localAddresses;
          await prefs.setString('userDetails', jsonEncode(userMap));
        }

        // Success message
        Get.snackbar("Success", "Address updated successfully.");
        Get.to(UserSettings());
      } else {
        Get.snackbar("Error", "User document not found.");
      }
    } catch (e) {
      print('Error updating address: $e');
      Get.snackbar("Error", "Failed to update address.");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize the text fields with the passed data
    initTextControllers();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Address"), // Changed to "Update Address"
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
              const SizedBox(height: 8),
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
              const SizedBox(height: 15),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 75, vertical: 12),
                ),
              ),
              const SizedBox(height: 15),
              Text("Building Number",
                  style: TextStyle(
                      color: CustomColors.textColorThree, fontSize: 16)),
              const SizedBox(height: 8),
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
              const SizedBox(height: 15),
              TextField(
                controller: addAddressController.floorController,
                onChanged: (_) => checkFields(),
                keyboardType:
                    TextInputType.number, // Set keyboard type to number
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Allow only digits
                ],
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
              const SizedBox(height: 15),
              Text("Landmark",
                  style: TextStyle(
                      color: CustomColors.textColorThree, fontSize: 16)),
              const SizedBox(height: 8),
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
              const SizedBox(height: 100),
              Obx(() => ElevatedButton(
                    onPressed: isAllFieldsFilled.value
                        ? () async {
                            try {
                              await updateAddress();
                            } catch (e) {
                              print('Error in button onPressed: $e');
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 120, vertical: 15),
                      backgroundColor: isAllFieldsFilled.value
                          ? CustomColors.textColorThree
                          : Colors.white,
                      side: BorderSide(color: CustomColors.textColorThree),
                    ),
                    child: Text(
                      'Save Edit Changes', // Changed to "Save Edit Changes"
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
