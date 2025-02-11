import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/device/device_utility.dart';
import '../../utils/helpers/helper_functions.dart';
import '../../view_model/getx/onboarding_controller/onboarding_controller.dart';

class OnBoardingDotNavigation extends StatelessWidget {
  const OnBoardingDotNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingController.instance;
    final dark = AppHelperFunctions.isDarkMode(context);

    return Positioned(
      bottom: AppDeviceUtility.getBottomNavigationBarHeight() - 10,
      left: AppSizes.defaultSpacing,
      child: SmoothPageIndicator(
        count: 4,
        controller: controller.pageController,
        onDotClicked: controller.dotNavigationClick,
        effect: ExpandingDotsEffect(
          activeDotColor: dark ? AppColors.lightBlue : AppColors.blue900,
          dotHeight: 6,
        ),
      ),
    );
  }
}
