import 'package:flutter/material.dart';
import 'package:talk_nest/utils/constants/colors.dart';

class ElevatedButtonThemes {
  ElevatedButtonThemes._();

  static ElevatedButtonThemeData liteElevatedButtonTheme =
      ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(color: AppColors.blue900)),
    backgroundColor: AppColors.lightBlue,
    textStyle: const TextStyle(color: AppColors.blackMe),
  ));

  static ElevatedButtonThemeData darkElevatedButtonTheme =
      ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(color: AppColors.white)),
    backgroundColor: AppColors.blue900,
    textStyle: const TextStyle(color: AppColors.white),
  ));
}
