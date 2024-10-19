import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/user/screens/edit_address_page.dart';
import 'package:house_cleaning/user/screens/user_add_address.dart';
import 'package:house_cleaning/user/screens/user_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../auth/model/usermodel.dart';
import '../../auth/provider/auth_provider.dart';
import '../../generated/l10n.dart';
import '../../theme/custom_colors.dart';
import '../widgets/address_widget.dart';
import '../widgets/custom_button_widget.dart';

class ManageAddress extends StatefulWidget {
  const ManageAddress({Key? key}) : super(key: key);

  @override
  _ManageAddressState createState() => _ManageAddressState();
}

class _ManageAddressState extends State<ManageAddress> {
  var addresses = <AddressModel>[].obs; // Observable list of AddressModel
  var isLoading = false.obs; // Observable to track loading state

  @override
  void initState() {
    super.initState();
    fetchAddresses(); // Fetch addresses when the widget initializes
  }

  Future<void> fetchAddresses() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userDocId'); // Retrieve user ID

      if (userId == null) {
        print('User ID not found in SharedPreferences');
        return;
      }

      var snapshot = await FirebaseFirestore.instance
          .collection('users_table') // Fetch from 'users_table'
          .doc(userId)
          .get();

      if (snapshot.exists && snapshot.data()!.containsKey('address')) {
        var addressData = snapshot.data()!['address'] as List<dynamic>;
        addresses.value = addressData
            .map((data) =>
                AddressModel.fromFirestore(data as Map<String, dynamic>))
            .toList();
        print('Fetched ${addresses.length} addresses for user');
      } else {
        print('No addresses found for this user');
      }
    } catch (e) {
      print("Error fetching addresses: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void editAddress(AddressModel address) {
    Get.to(() => EditAddressPage(), arguments: {
      'address': address,
    }); // Passing address and userId to edit page
  }

  void removeAddress(AddressModel address) async {
    print("Removing address: ${address.building}");

    // Get the user ID from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userDocId');

    if (userId == null) {
      print("User ID not found in SharedPreferences.");
      return; // Early exit if user ID is not found
    }

    try {
      // Fetch the user's addresses from Firestore
      var snapshot = await FirebaseFirestore.instance
          .collection('users_table')
          .doc(userId)
          .get();

      List<dynamic> addressList = snapshot.data()?['address'] ?? [];

      // Debug: Print all addresses
      print('Current addresses: $addressList');

      // Find the index of the address to remove based on building and geolocation
      int indexToRemove = -1;
      for (int i = 0; i < addressList.length; i++) {
        var item = addressList[i];
        if (item['Building'] == address.building &&
            item['Geolocation'][0].toString() == address.geolocation.lat &&
            item['Geolocation'][1].toString() == address.geolocation.lon) {
          indexToRemove = i;
          break;
        }
      }

      if (indexToRemove == -1) {
        print("Address not found in the list.");
        return;
      }

      // Remove the address at the found index
      addressList.removeAt(indexToRemove);

      // Update the Firestore document with the new address list
      await FirebaseFirestore.instance
          .collection('users_table')
          .doc(userId)
          .update({'address': addressList});

      print("Address removed successfully from Firestore.");

      // Update SharedPreferences
      String? userDetailsJson = prefs.getString('userDetails');
      if (userDetailsJson != null) {
        Map<String, dynamic> userMap = jsonDecode(userDetailsJson);

        // Debug: Print the current addresses in SharedPreferences
        print(
            "Addresses in SharedPreferences before removal: ${userMap['address']}");

        // Remove the address from SharedPreferences by index
        (userMap['address'] as List).removeAt(indexToRemove);

        // Save updated user details back to SharedPreferences
        await prefs.setString('userDetails', jsonEncode(userMap));
        print("User details updated successfully in SharedPreferences.");
        Get.to(UserSettings()); // Go back after updating
      }
    } catch (e) {
      print("Error removing address: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).manageAddresses)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (addresses.isEmpty) ...[
                Text(S.of(context).noAddressesAvailable),
              ] else ...[
                // Iterate through the address list and build AddressSection for each
                for (var address in addresses) ...[
                  AddressSection(
                    addressModel: address, // Pass the full AddressModel
                    onEdit: () => editAddress(address), // Handle Edit
                    onRemove: () => removeAddress(address), // Handle Remove
                  ),
                  Divider(color: Colors.grey[300]), // Divider line
                ],
              ],
              const Spacer(), // To push the button to the bottom
              Center(
                child: CustomButton(
                  text: S.of(context).addNewAddress,
                  onTap: () {
                    Get.to(() => UserAddAddressPage());
                  },
                  icon: Icon(
                    Icons.add,
                    color: CustomColors.textColorThree,
                  ),
                  horizontalPadding: 50,
                  verticalPadding: 15,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
