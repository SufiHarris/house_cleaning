import 'package:flutter/material.dart';

import '../theme/custom_colors.dart';

class CustomStyles {
  static OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderSide:
        BorderSide(color: CustomColors.textfieldBorderColor, width: 1.5),
    borderRadius: const BorderRadius.all(
      Radius.circular(6.0),
    ),
  );
}
