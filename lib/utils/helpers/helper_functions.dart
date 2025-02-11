import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../view_model/provider/auth_provider.dart';

class AppHelperFunctions {
  static void showSnackBar(String message) {
    ScaffoldMessenger.of(Get.context!)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  static navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => screen,
        ));
  }

  static navigateToScreenBeforeEndPage(BuildContext context, Widget screen) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => screen,
        ));
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static splaceController(BuildContext context) {
    final provider = Provider.of<AuthProviderIn>(
      context,
      listen: false,
    );
    Timer(
      Duration(seconds: 3),
      () {
        provider.checkUserLoginStutas();
      },
    );
  }
}
