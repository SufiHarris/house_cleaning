import 'package:flutter/material.dart';
import 'package:house_cleaning/theme/custom_colors.dart';

class AddressSection extends StatelessWidget {
  final String addressTitle;
  final String address;

  const AddressSection({
    Key? key,
    required this.addressTitle,
    required this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          addressTitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: CustomColors.textColorThree, // Custom color for title

                fontSize: 16,
              ),
        ),
        SizedBox(height: 8),
        Text(
          address,
          style: TextStyle(
            color: Colors.black54,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  // Remove address logic here
                },
                child: Text(
                  "Remove",
                  style: TextStyle(
                    color:
                        CustomColors.textColorThree, // Custom color for button
                    fontWeight: FontWeight.w400,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: CustomColors.textColorThree),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  // Edit address logic here
                },
                child: Text(
                  "Edit",
                  style: TextStyle(
                    color: CustomColors.textColorThree,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: CustomColors.textColorThree),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
