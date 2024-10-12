import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/user/screens/user_add_address.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../auth/model/usermodel.dart';
import '../../auth/provider/auth_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Get.find<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Address")),
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
                const Text("No addresses available."),
              ] else ...[
                // Iterate through the address list and build AddressSection for each
                for (var address in addresses) ...[
                  AddressSection(
                    addressTitle: address.building,
                    address: address.building,
                  ),
                  Divider(color: Colors.grey[300]), // Divider line
                ],
              ],
              const Spacer(), // To push the button to the bottom
              Center(
                child: CustomButton(
                  text: 'Add New Address',
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
