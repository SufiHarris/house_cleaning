import 'package:flutter/material.dart';
import '../../theme/custom_colors.dart';

class TimeSelectionPage extends StatelessWidget {
  const TimeSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: CustomColors.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Time Availability",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: CustomColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 24),
            Text("Available From"),
            _buildTimePicker(context, "12:30 AM"),
            const SizedBox(height: 24),
            Text("Available To"),
            _buildTimePicker(context, "02:00 AM"),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker(BuildContext context, String time) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Logic to show Time Picker
            },
            child: Text(time),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              side: BorderSide(color: CustomColors.primaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const SizedBox(width: 16),
        ToggleButtons(
          isSelected: const [true, false],
          children: [
            Text("AM", style: TextStyle(color: CustomColors.eggPlant)),
            Text("PM", style: TextStyle(color: CustomColors.primaryColor)),
          ],
          onPressed: (int index) {
            // Toggle AM/PM
          },
          borderRadius: BorderRadius.circular(10),
          borderColor: CustomColors.primaryColor,
        ),
      ],
    );
  }
}
