import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_cleaning/user/screens/user_add_address.dart';

import '../../auth/provider/auth_provider.dart';
import '../../theme/custom_colors.dart';
import '../models/address_model.dart';
import '../widgets/address_widget.dart';
import '../widgets/custom_button_widget.dart';

class ManageAddress extends StatelessWidget {
  const ManageAddress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Get.find<AuthProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text("Address")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Iterate through the address list and build AddressSection for each
            for (var address in addressList) ...[
              AddressSection(
                addressTitle: address.addressTitle,
                address: address.address,
              ),

              Divider(color: Colors.grey[300]), // Divider line
            ],

            Spacer(), // To push the button to the bottom
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
        ),
      ),
    );
  }
}
