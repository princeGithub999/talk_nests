import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:talk_nest/utils/helpers/helper_functions.dart';
import '../../utils/constants/colors.dart';
import '../../view_model/provider/auth_provider.dart';

class ProfileImage {
  static Consumer<Object?> profileImage() {
    final isDark = AppHelperFunctions.isDarkMode(Get.context!);
    final sizes = MediaQuery.of(Get.context!).size;

    return Consumer<AuthProviderIn>(
      builder: (BuildContext context, authProvider, Widget? child) {
        return InkWell(
          onTap: () {
            authProvider.pickImageFromGallery();
          },
          child: CircleAvatar(
            maxRadius: 50,
            backgroundColor: isDark ? AppColors.blue900 : AppColors.lightBlue,
            child: ClipOval(
              child: authProvider.imageFile != null
                  ? Image.file(
                      File(authProvider.imageFile!.path),
                      height: sizes.height * 0.1 + 10,
                      width: sizes.width * 0.2 + 15,
                      fit: BoxFit.cover,
                    )
                  : const Icon(
                      Icons.person,
                      size: 60,
                    ),
            ),
          ),
        );
      },
    );
  }
}
