import 'package:flutter/material.dart';
import 'package:house_cleaning/theme/custom_colors.dart';
import '../../auth/model/usermodel.dart'; // Import AddressModel

class AddressSection extends StatelessWidget {
  final AddressModel addressModel;
  final VoidCallback onEdit; // Callback for the Edit button
  final VoidCallback onRemove; // Callback for the Remove button

  const AddressSection({
    Key? key,
    required this.addressModel, // Accept the full AddressModel
    required this.onEdit, // Accept the callback for Edit action
    required this.onRemove, // Accept the callback for Remove action
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display Building Name
        Text(
          "Building: ${addressModel.building}",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: CustomColors.textColorThree, // Custom color for title
                fontSize: 16,
              ),
        ),
        const SizedBox(height: 8),

        // Display Floor
        Text(
          "Floor: ${addressModel.floor}",
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),

        // Display Landmark
        Text(
          "Landmark: ${addressModel.landmark}",
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),

        // Display Location
        Text(
          "Location: ${addressModel.location}",
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),

        // Display Geolocation (latitude and longitude)
        Text(
          "Geolocation: Lat ${addressModel.geolocation.lat}, Lon ${addressModel.geolocation.lon}",
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),

        // Divider line between address and buttons
        Divider(color: Colors.grey[300]),

        // Buttons for Edit and Remove
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Remove Button
            Expanded(
              child: OutlinedButton(
                onPressed: onRemove, // Call the remove address function
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
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            const SizedBox(width: 20),

            // Edit Button
            Expanded(
              child: OutlinedButton(
                onPressed: onEdit, // Call the edit address function
                child: Text(
                  "Edit",
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
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
