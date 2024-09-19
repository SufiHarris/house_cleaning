import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
import 'package:house_cleaning/theme/custom_colors.dart';

class ProfileMenuItem extends StatelessWidget {
  final String svgIconPath;
  final String text;
  final VoidCallback onTap;

  ProfileMenuItem({
    required this.svgIconPath,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
          child: Row(
            children: [
              SvgPicture.asset(
                svgIconPath,
                color: Color(0xFF6B3F3A),
                width: 15,
                height: 19,
              ),
              SizedBox(width: 20),
              Expanded(
                child: Text(text,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: CustomColors.textColorFour,
                        )),
              ),
              Icon(Icons.arrow_forward_ios, color: Color(0xFF6B3F3A), size: 16),
            ],
          ),
        ));
  }
}
