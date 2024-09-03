import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../theme/custom_colors.dart';

class ImageButton extends StatelessWidget {
  final String imageUrl;
  const ImageButton({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 10,
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
            side: BorderSide(color: CustomColors.textfieldBorderColor)),
      ),
      child: SvgPicture.asset(
        imageUrl,
        width: 26,
        height: 26,
      ),
    );
  }
}
