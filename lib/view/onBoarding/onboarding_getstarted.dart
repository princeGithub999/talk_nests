import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talk_nest/utils/constants/colors.dart';
import 'package:talk_nest/utils/constants/sizes.dart';
import 'package:talk_nest/utils/device/device_utility.dart';
import 'package:talk_nest/view/onBoarding/onboarding_next_button.dart';

import '../../utils/helpers/helper_functions.dart';
import '../../view_model/getx/onboarding_controller/onboarding_controller.dart';

class OnboardingGetstarted extends StatelessWidget {
  const OnboardingGetstarted({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingController.instance;
    final dark = AppHelperFunctions.isDarkMode(context);

    return Obx(() {
      return controller.isGetStarted.value
          ? Positioned(
              right: AppSizes.defaultSpacing,
              bottom: AppDeviceUtility.getBottomNavigationBarHeight() - 30,
              child: ElevatedButton(
                onPressed: () => controller.nextPage(),
                child: Text(
                  'Get Started',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        dark ? AppColors.lightBlue : AppColors.blue900,
                    padding: EdgeInsets.symmetric(horizontal: 40)),
              ),
            )
          : OnBoardNextButton();
    });
  }
}
