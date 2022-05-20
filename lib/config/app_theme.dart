import 'package:flutter/material.dart';

class AppTheme {
  static const primaryColor = Color(0x00000000);
  static const secondaryColor = Color(0xFFF2BF42);
  static const darkGray = Color(0xFF979797);
  static const grey = Color(0xFFACACAC);
  static const white = Color(0xFFFFFFFF);
  static const red = Color(0xFFDB3022);
  static const lightGray = Color(0xFF9B9B9B);
  static const orange = Color(0xFFFFBA49);
  static const background = Color(0xFFFFFFFF);
  static const backgroundLight = Color.fromARGB(255, 61, 58, 106); //(0xFF3D3A6A);
  static const black = Color(0x00000000);
  static const success = Color(0xFF2AA952);
  static const disable = Color(0xFF929794);

  static ThemeData of(context) {
    var theme = Theme.of(context);
    return theme.copyWith(
      colorScheme: theme.colorScheme.copyWith(secondary: secondaryColor),
      primaryColor: primaryColor,
      primaryColorLight: lightGray,
      bottomAppBarColor: lightGray,
      backgroundColor: background,
      scaffoldBackgroundColor: background,
      errorColor: red,
      dividerColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        color: secondaryColor
      )
    );
  }
}
