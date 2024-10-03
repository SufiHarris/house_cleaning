import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/user/screens/product_recommend_screen.dart';
import 'package:house_cleaning/user/screens/user_add_address.dart';
import '../../theme/custom_colors.dart';
import '../models/address_model.dart';
import '../providers/user_provider.dart';
import '../widgets/custom_button_widget.dart';

class UserSelectAddress extends StatefulWidget {
  const UserSelectAddress({Key? key}) : super(key: key);

  @override
  State<UserSelectAddress> createState() => _UserSelectAddressState();
}

class _UserSelectAddressState extends State<UserSelectAddress> {
  final userProvider = Get.find<UserProvider>();

  @override
  void initState() {
    super.initState();
    userProvider.fetchAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Address")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (userProvider.addresses.isEmpty)
                const Center(child: Text('No addresses found.'))
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: userProvider.addresses.length,
                    itemBuilder: (context, index) {
                      final address = userProvider.addresses[index];
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: RadioListTile<AddressModel>(
                              value: address,
                              groupValue: userProvider.selectedAddress.value,
                              onChanged: (AddressModel? selectedAddress) {
                                setState(() {
                                  userProvider
                                      .setSelectedAddress(selectedAddress!);
                                });
                              },
                              activeColor: CustomColors.primaryColor,
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
                              secondary: Icon(Icons.location_on,
                                  color: CustomColors.primaryColor),
                            ),
                          ),
                          const Divider(),
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
                child: Obx(() {
                  // Disable the Next button if no address is selected
                  return CustomButton(
                    text: 'Next',
                    onTap: userProvider.selectedAddress.value != null
                        ? () {
                            Get.to(() => ProductRecommendScreen());
                          }
                        : () {
                            // Show error message if no address is selected
                            Get.snackbar('Error', 'Please select an address',
                                snackPosition: SnackPosition.BOTTOM);
                          },
                    // isDisabled: userProvider.selectedAddress.value == null,
                  );
                }),
              ),
            ],
          );
        }),
      ),
    );
  }
}
