import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:talk_nest/utils/constants/app_string.dart';
import 'package:talk_nest/utils/helpers/helper_functions.dart';

import '../../view_model/provider/auth_provider.dart';
import '../constants/colors.dart';
import '../constants/images.dart';

class ButtonWidget {
  final sizes = MediaQuery.of(Get.context!).size;
  final isDark = AppHelperFunctions.isDarkMode(Get.context!);

  static Widget googleAuthButton(
    VoidCallback onPress,
  ) {
    final sizes = MediaQuery.of(Get.context!).size;
    final isDark = AppHelperFunctions.isDarkMode(Get.context!);

    return ElevatedButton(
        onPressed: () => onPress,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? AppColors.blue900 : AppColors.lightBlue,
          shape: CircleBorder(
              side: BorderSide(
                  color: isDark ? AppColors.white : AppColors.blue900,
                  width: 1)),
        ),
        child: Image.asset(
          AppImage.googleIcon,
          height: sizes.height * 0.1 - 65,
        ));
  }

  static Widget facebookAuthButton(
    VoidCallback onPress,
  ) {
    final sizes = MediaQuery.of(Get.context!).size;
    final isDark = AppHelperFunctions.isDarkMode(Get.context!);

    return ElevatedButton(
        onPressed: () => onPress,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? AppColors.blue900 : AppColors.lightBlue,
          shape: CircleBorder(
              side: BorderSide(
                  color: isDark ? AppColors.white : AppColors.blue900,
                  width: 1)),
        ),
        child: Image.asset(
          AppImage.facebookIcon,
          height: sizes.height * 0.1 - 65,
        ));
  }

  static Widget signInButton(VoidCallback onPress) {
    final isDark = AppHelperFunctions.isDarkMode(Get.context!);

    return Consumer<AuthProviderIn>(
      builder: (BuildContext context, authProvider, Widget? child) {
        return ElevatedButton(
          onPressed: () {
            onPress();
          },
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 80)),
          child: authProvider.isLoding
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(),
                )
              : Text(
                  AppString.signIn,
                  style: TextStyle(color: isDark ? Colors.white : Colors.white),
                ),
        );
      },
    );
  }

  static Widget signUpButton(VoidCallback onPress) {
    final isDark = AppHelperFunctions.isDarkMode(Get.context!);
    final sizes = MediaQuery.of(Get.context!).size;

    return Consumer<AuthProviderIn>(
      builder: (BuildContext context, authProvider, Widget? child) {
        return ElevatedButton(
            onPressed: () {
              onPress();
            },
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 80)),
            child: authProvider.isLoding
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: AppColors.white,
                    ))
                : Text(
                    'Sign Up',
                    style:
                        TextStyle(color: isDark ? Colors.white : Colors.white),
                  ));
      },
    );
  }

  static Widget textButton(VoidCallback onPress, String hintText) {
    return TextButton(
        onPressed: () {
          onPress();
        },
        child: Text(
          hintText,
          style: Theme.of(Get.context!).textTheme.titleMedium,
        ));
  }

  static Widget forgotButton(VoidCallback onPress) {
    return Consumer<AuthProviderIn>(
      builder: (BuildContext context, authProvider, Widget? child) {
        return ElevatedButton(
          onPressed: () {
            onPress();
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 150),
          ),
          child: authProvider.isLoding
              ? const CircularProgressIndicator()
              : Text(
                  AppString.forgotButtom,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
        );
      },
    );
  }

  static iconButtomM(VoidCallback onPress, IconData icon) async {
    IconButton(
        onPressed: () {
          onPress();
        },
        icon: Icon(icon));
  }

  static Widget anyWereButtom(VoidCallback onPress, String hintName) {
    return ElevatedButton(
      onPressed: () {
        onPress();
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 140),
        // backgroundColor: Colors.blueGrey,
      ),
      child: Text(
        hintName,
        style: Theme.of(Get.context!).textTheme.titleSmall,
      ),
    );
  }
}
