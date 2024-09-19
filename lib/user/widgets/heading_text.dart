import 'package:flutter/material.dart';

import '../../theme/custom_colors.dart';

class HeadingText extends StatelessWidget {
  final String headingText;
  const HeadingText({
    required this.headingText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            headingText,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: CustomColors.textColorTwo, fontSize: 18),
          )
        ],
      ),
    );
  }
}
