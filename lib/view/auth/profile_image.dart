import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                  : Icon(Icons.person),
            ),
          ),
        );
      },
    );
  }

  static Consumer<Object?> profileImageUpdate() {
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
                  : CachedNetworkImage(
                      imageUrl: authProvider.currentUser.userImage!,
                      fit: BoxFit.cover,
                      width: sizes.width * 0.2 + 15,
                      height: sizes.height * 0.1 + 10,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
            ),
          ),
        );
      },
    );
  }
}
