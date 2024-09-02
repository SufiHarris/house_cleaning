import 'package:flutter/material.dart';
import 'package:house_cleaning/theme/custom_colors.dart';

class CustomTheme {
  static ThemeData themeData = ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: CustomColors.seedColor,
          primary: CustomColors.primaryColor),
      textTheme: const TextTheme());
}
