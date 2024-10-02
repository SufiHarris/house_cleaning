import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/user/models/service_summary_model.dart';
import 'package:house_cleaning/user/screens/user_add_address.dart';

import '../../auth/provider/auth_provider.dart';
import '../../theme/custom_colors.dart';
import '../models/address_model.dart';
import '../providers/user_provider.dart';
import '../widgets/custom_button_widget.dart';

class UserSelectAddress extends StatefulWidget {
  final List<ServiceSummaryModel> summary;

  const UserSelectAddress({Key? key, required this.summary}) : super(key: key);

  @override
  State<UserSelectAddress> createState() => _UserSelectAddressState();
}

class _UserSelectAddressState extends State<UserSelectAddress> {
  final userProvider = Get.find<UserProvider>();

  // Track the selected address
  int _selectedAddressIndex = 0;

  @override
  void initState() {
    super.initState();
    // Fetch addresses when the widget is initialized
    userProvider.fetchAddresses();
  }

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Get.find<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Select Address")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          // Use Obx to make the widget reactive
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (userProvider.addresses.isEmpty)
                const Center(child: Text('No addresses found.'))
              else
                // Use ListView.builder to display each address with Radio buttons
                Expanded(
                  child: ListView.builder(
                    itemCount: userProvider.addresses.length,
                    itemBuilder: (context, index) {
                      final address = userProvider.addresses[index];

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: RadioListTile<int>(
                              value: index,
                              groupValue: _selectedAddressIndex,
                              onChanged: (value) {
                                setState(() {
                                  _selectedAddressIndex = value!;
                                });
                              },
                              activeColor: CustomColors
                                  .primaryColor, // Customize as needed
                              title: Text(
                                address.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                '${address.city}, ${address.building}, ${address.landmark}, ${address.floor}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                              secondary: const Icon(Icons.location_on,
                                  color: Colors.red),
                            ),
                          ),
                          Divider()
                        ],
                      );
                    },
                  ),
                ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
              Center(
                child: CustomButton(
                  text: 'Next',
                  onTap: () {
                    // Implement the logic when "Next" button is pressed
                  },
                  horizontalPadding: 50,
                  verticalPadding: 15,
                  // backgroundColor:
                  //     CustomColors.primaryColor, // Customize as needed
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
