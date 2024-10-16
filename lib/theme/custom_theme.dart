import 'package:flutter/material.dart';
import 'package:house_cleaning/theme/custom_colors.dart';

class CustomTheme {
  static ThemeData themeData = ThemeData(
    fontFamily: 'Montserrat',
    scaffoldBackgroundColor: CustomColors.eggPlant,
    colorScheme: ColorScheme.fromSeed(
        seedColor: CustomColors.seedColor, primary: CustomColors.primaryColor),
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      bodySmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      labelMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: CustomColors.primaryColor,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      prefixIconColor: CustomColors.hintColor,
      filled: true,
      fillColor: CustomColors.textfieldBackgroundColor,
      hintStyle: TextStyle(color: CustomColors.hintColor),
      enabledBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: CustomColors.textfieldBorderColor, width: 1),
        borderRadius: const BorderRadius.all(
          Radius.circular(40.0),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: CustomColors.textfieldBorderColor, width: 1),
        borderRadius: const BorderRadius.all(
          Radius.circular(40.0),
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(
            color: CustomColors.primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.w600),
        centerTitle: true,
        backgroundColor: Colors.white),
  );
}
