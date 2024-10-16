import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme/custom_colors.dart';

class ManagementWidget extends StatelessWidget {
  final String iconString;
  final String nameString;
  const ManagementWidget(
      {super.key, required this.iconString, required this.nameString});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SvgPicture.asset(iconString),
          SizedBox(
            width: 20,
          ),
          Text(
            nameString,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500, color: CustomColors.textColorTwo),
          ),
          Spacer(),
          Icon(Icons.chevron_right)
        ],
      ),
    );
  }
}
