import 'package:flutter/material.dart';

import '../../theme/custom_colors.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back, color: Colors.brown), // Back button color
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Terms & Conditions',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: CustomColors.textColorFour,
                  fontSize: 20,
                )),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Experience top-notch home cleaning with our expert team. Quick, reliable, and thorough—making your home sparkle effortlessly!',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: CustomColors.textColorThree,
                    )),
            SizedBox(height: 16), // Space between texts
            Text(
                'Experience top-notch home cleaning with our expert team. Quick, reliable, and thorough—making your home sparkle effortlessly!',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: CustomColors.textColorFour,
                    )),
            SizedBox(height: 16), // Space between texts
            Text(
                'Experience top-notch home cleaning with our expert team. Quick, reliable, and thorough—making your home sparkle effortlessly!',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: CustomColors.textColorFour,
                    )),
          ],
        ),
      ),
    );
  }
}
