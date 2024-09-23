import 'package:flutter/material.dart';

import '../../theme/custom_colors.dart';
import '../widgets/address_widget.dart';

class ManageAddress extends StatelessWidget {
  const ManageAddress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Manage Address",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: CustomColors.textColorThree,
                )),
        iconTheme: IconThemeData(
          color: CustomColors.textColorThree, // Back arrow color
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AddressSection(
              addressTitle: "Home Address",
              address: "1234 Desert Oasis Street, Riyadh, Saudi Arabia, 12345",
            ),

            Divider(color: Colors.grey[300]), // Divider line
            AddressSection(
              addressTitle: "Office Address",
              address: "1234 Desert Oasis Street, Riyadh, Saudi Arabia, 12345",
            ),
            Spacer(), // To push the button to the bottom
            Center(
              child: OutlinedButton.icon(
                onPressed: () {
                  // Add new address logic here
                },
                icon: Icon(
                  Icons.add,
                  color: CustomColors.textColorThree,
                ),
                label: Text(
                  "+ Add New Address",
                  style: TextStyle(
                    color: CustomColors.textColorThree,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: CustomColors.textColorThree),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
