import 'package:flutter/material.dart';
import 'package:house_cleaning/theme/custom_colors.dart';

class CustomTheme {
  static ThemeData themeData = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(
        seedColor: CustomColors.seedColor, primary: CustomColors.primaryColor),
    textTheme: const TextTheme(),
    inputDecorationTheme: InputDecorationTheme(
      prefixIconColor: CustomColors.hintColor,
      filled: true,
      fillColor: CustomColors.textfieldBackgroundColor,
      hintStyle: TextStyle(color: CustomColors.hintColor),
      enabledBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: CustomColors.textfieldBorderColor, width: 1),
        borderRadius: const BorderRadius.all(
          Radius.circular(6.0),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: CustomColors.textfieldBorderColor, width: 1),
        borderRadius: const BorderRadius.all(
          Radius.circular(6.0),
        ),
      ),
    ),
  );
}
