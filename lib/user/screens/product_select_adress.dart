import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/auth/model/usermodel.dart';
import 'package:house_cleaning/user/models/product_model.dart';
import 'package:house_cleaning/user/screens/user_add_address.dart';
import 'package:house_cleaning/user/screens/user_main.dart';
import '../../theme/custom_colors.dart';
import '../providers/user_provider.dart';
import '../widgets/custom_button_widget.dart';

class ProductSelectAdress extends StatefulWidget {
  final UserProductModel product;

  const ProductSelectAdress({Key? key, required this.product})
      : super(key: key);

  @override
  State<ProductSelectAdress> createState() => _ProductSelectAdressState();
}

class _ProductSelectAdressState extends State<ProductSelectAdress> {
  final userProvider = Get.find<UserProvider>();

  @override
  void initState() {
    super.initState();
    //  userProvider.fetchAddresses();
    userProvider.getUserAddresses();

    // Optionally, set a default selected address if there are existing addresses
    if (userProvider.addresses.isNotEmpty) {
      userProvider.setSelectedAddress(
          userProvider.addresses.first); // Set the first address as selected
    }
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
                                // Set the selected address
                                userProvider
                                    .setSelectedAddress(selectedAddress!);
                              },
                              activeColor: CustomColors.primaryColor,
                              title: Text(
                                address.landmark,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                '${address.landmark}, ${address.building}, ${address.floor}',
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
                    text: 'Add To Cart',
                    onTap: userProvider.selectedAddress.value != null
                        ? () {
                            userProvider.addProductToCart(widget.product);
                            Get.to(() => UserMain());
                          }
                        : () {
                            // Show error message if no address is selected
                            Get.snackbar('Error', 'Please select an address',
                                snackPosition: SnackPosition.BOTTOM);
                          },
                    isDisabled: userProvider.selectedAddress.value == null,
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
