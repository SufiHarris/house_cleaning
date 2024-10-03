import 'package:flutter/material.dart';
import 'package:house_cleaning/theme/custom_colors.dart';

class ConfirmOrderEdit extends StatelessWidget {
  final String title;
  final VoidCallback onClick;
  const ConfirmOrderEdit(
      {super.key, required this.title, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: CustomColors.textColorOne),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onClick, // Update: directly pass the onClick function here
          child: Text(
            "Edit",
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: CustomColors.textColorOne,
                decoration: TextDecoration.underline),
          ),
        )
      ],
    );
  }
}
