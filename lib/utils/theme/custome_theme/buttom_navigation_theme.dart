import 'package:flutter/material.dart';
import 'package:talk_nest/utils/constants/colors.dart';

class ButtomNavigationTheme {
  ButtomNavigationTheme._();

  static BottomNavigationBarThemeData buttomNavLiteMode =
      BottomNavigationBarThemeData(
          backgroundColor: AppColors.lightBlue, selectedItemColor: Colors.red);

  static BottomNavigationBarThemeData buttomNavDarkMode =
      BottomNavigationBarThemeData(
    backgroundColor: AppColors.blue900,
    selectedItemColor: Colors.black,
  );
}
