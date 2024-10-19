import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../auth/provider/auth_provider.dart';
import '../../generated/l10n.dart';
import '../../theme/custom_colors.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Get.find<AuthProvider>();
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).termsAndConditions)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
