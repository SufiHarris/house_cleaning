// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:house_cleaning/user/screens/user_googlemap.dart';
// import '../../theme/custom_colors.dart';
// import '../widgets/custom_button_widget.dart';
// import 'controller/user_addaddress_controller.dart';

// class UserAddAddressPage extends StatelessWidget {
//   UserAddAddressPage({super.key});
//   final AddAddressController addAddressController =
//       Get.put(AddAddressController());
//   bool isNextPressed = false;

//   final TextEditingController locationController = TextEditingController();
//   final TextEditingController buildingController = TextEditingController();
//   final TextEditingController floorController = TextEditingController();
//   final TextEditingController landmarkController = TextEditingController();

//   final RxBool isAllFieldsFilled = false.obs;

//   void checkFields() {
//     isAllFieldsFilled.value =
//         addAddressController.locationController.text.isNotEmpty &&
//             addAddressController.buildingController.text.isNotEmpty &&
//             addAddressController.floorController.text.isNotEmpty &&
//             addAddressController.landmarkController.text.isNotEmpty;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Add New Address"), // Customize as needed
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("Enter Location",
//                   style: TextStyle(
//                       color: CustomColors.textColorThree, fontSize: 16)),
//               SizedBox(height: 8),
//               TextField(
//                 controller: addAddressController.locationController,
//                 onChanged: (_) => checkFields(),
//                 decoration: InputDecoration(
//                   hintText: 'Enter location',
//                   labelStyle:
//                       const TextStyle(color: Color(0xFFDCD7D8), fontSize: 16),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30.0),
//                     borderSide: const BorderSide(color: Color(0xFFDCD7D8)),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30.0),
//                     borderSide: BorderSide(color: CustomColors.textColorThree),
//                   ),
//                   contentPadding:
//                       const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//                 ),
//               ),
//               SizedBox(height: 15),
//               ElevatedButton.icon(
//                 onPressed: () async {
//                   LatLng selectedLocation =
//                       await Get.to(() => SelectLocationOnMapPage());
//                   if (selectedLocation != null) {
//                     await addAddressController
//                         .setLocationFromMap(selectedLocation);
//                   }
//                 },
//                 icon: Icon(Icons.location_pin,
//                     color: CustomColors.textColorThree),
//                 label: Text("Use Current Location",
//                     style: TextStyle(color: CustomColors.textColorThree)),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30.0),
//                     side: BorderSide(color: CustomColors.textColorThree),
//                   ),
//                   elevation: 0,
//                   padding: EdgeInsets.symmetric(horizontal: 75, vertical: 12),
//                 ),
//               ),
//               SizedBox(height: 15),
//               Text("Building Number",
//                   style: TextStyle(
//                       color: CustomColors.textColorThree, fontSize: 16)),
//               SizedBox(height: 8),
//               TextField(
//                 controller: addAddressController.buildingController,
//                 onChanged: (_) => checkFields(),
//                 decoration: InputDecoration(
//                   hintText: 'Enter building number',
//                   labelStyle:
//                       const TextStyle(color: Color(0xFFDCD7D8), fontSize: 16),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30.0),
//                     borderSide: const BorderSide(color: Color(0xFFDCD7D8)),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30.0),
//                     borderSide: BorderSide(color: CustomColors.textColorThree),
//                   ),
//                   contentPadding:
//                       const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//                 ),
//               ),
//               SizedBox(height: 15),
//               Text("Floor",
//                   style: TextStyle(
//                       color: CustomColors.textColorThree, fontSize: 16)),
//               SizedBox(height: 8),
//               TextField(
//                 controller: addAddressController.floorController,
//                 onChanged: (_) => checkFields(),
//                 decoration: InputDecoration(
//                   hintText: 'Enter your floor',
//                   labelStyle:
//                       const TextStyle(color: Color(0xFFDCD7D8), fontSize: 16),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30.0),
//                     borderSide: const BorderSide(color: Color(0xFFDCD7D8)),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30.0),
//                     borderSide: BorderSide(color: CustomColors.textColorThree),
//                   ),
//                   contentPadding:
//                       const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//                 ),
//               ),
//               SizedBox(height: 15),
//               Text("Landmark",
//                   style: TextStyle(
//                       color: CustomColors.textColorThree, fontSize: 16)),
//               SizedBox(height: 8),
//               TextField(
//                 controller: addAddressController.landmarkController,
//                 onChanged: (_) => checkFields(),
//                 decoration: InputDecoration(
//                   hintText: 'Enter landmark',
//                   labelStyle:
//                       const TextStyle(color: Color(0xFFDCD7D8), fontSize: 16),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30.0),
//                     borderSide: const BorderSide(color: Color(0xFFDCD7D8)),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30.0),
//                     borderSide: BorderSide(color: CustomColors.textColorThree),
//                   ),
//                   contentPadding:
//                       const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//                 ),
//               ),
//               SizedBox(height: 100),
//               Obx(() => ElevatedButton(
//                     onPressed: isAllFieldsFilled.value
//                         ? () async {
//                             await addAddressController.saveAddress();
//                             Get.back();
//                           }
//                         : null,
//                     style: ElevatedButton.styleFrom(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 120, vertical: 15),
//                       backgroundColor: isAllFieldsFilled.value
//                           ? CustomColors.textColorThree
//                           : Colors.white,
//                       side: BorderSide(color: CustomColors.textColorThree),
//                     ),
//                     child: Text(
//                       'Save Address',
//                       style: TextStyle(
//                         color: isAllFieldsFilled.value
//                             ? Colors.white
//                             : CustomColors.textColorThree,
//                       ),
//                     ),
//                   )),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:house_cleaning/auth/model/usermodel.dart';
import 'package:house_cleaning/auth/screens/fast_register.dart';
import 'package:house_cleaning/user/providers/user_provider.dart';
import 'package:house_cleaning/user/screens/controller/user_addaddress_controller.dart';
import 'package:house_cleaning/user/screens/product_recommend_screen.dart';
import 'package:house_cleaning/user/screens/user_googlemap.dart';
import 'package:house_cleaning/user/screens/user_select_address.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/custom_colors.dart';
import '../widgets/custom_button_widget.dart';

class UserAddAddressPage extends StatelessWidget {
  UserAddAddressPage({super.key});

  final AddAddressController addAddressController =
      Get.put(AddAddressController());
  final UserProvider userProvider = Get.put(UserProvider());
  bool isNextPressed = false;

  // You can remove these local controllers
  // final TextEditingController locationController = TextEditingController();
  // final TextEditingController buildingController = TextEditingController();
  // final TextEditingController floorController = TextEditingController();
  // final TextEditingController landmarkController = TextEditingController();

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
        title: const Text("Add New Address"),
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
                            // Check if user is logged in
                            // Check if user is logged in
                            if (userProvider.userId.value.isEmpty) {
                              print(
                                  'Building: ${addAddressController.buildingController.text}');
                              print(
                                  'Location: ${addAddressController.locationController.text}');
                              print(
                                  'Floor: ${addAddressController.floorController.text}');
                              print(
                                  'Landmark: ${addAddressController.landmarkController.text}');
                              print(
                                  'Latitude: ${addAddressController.currentLocation.value!.latitude}');
                              print(
                                  'Longitude: ${addAddressController.currentLocation.value!.longitude}');

                              AddressModel newAddress = AddressModel(
                                building: addAddressController
                                    .buildingController.text,
                                floor: int.tryParse(addAddressController
                                        .floorController.text) ??
                                    1,
                                geolocation: GeoLocationModel(
                                  lat: addAddressController
                                      .currentLocation.value!.latitude
                                      .toString(),
                                  lon: addAddressController
                                      .currentLocation.value!.longitude
                                      .toString(),
                                ),
                                landmark: addAddressController
                                    .landmarkController.text,
                                location: addAddressController
                                    .locationController.text,
                              );

                              print(
                                  'New Address: $newAddress'); // This will show the entire AddressModel

                              // Set the selected address in UserProvider
                              userProvider.setSelectedAddress(newAddress);

                              // Show a success message
                              Get.snackbar(
                                "Success",
                                "Address saved successfully.",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.greenAccent,
                                colorText: Colors.white,
                              );

                              // Optionally navigate to another screen
                              Get.to(() => ProductRecommendScreen());
                            } else {
                              // If user is logged in, save the address
                              await addAddressController.saveAddress();
                              Get.back();
                            }
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
