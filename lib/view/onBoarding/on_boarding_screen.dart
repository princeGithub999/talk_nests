import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:talk_nest/utils/constants/app_string.dart';
import 'package:talk_nest/utils/constants/colors.dart';
import 'package:talk_nest/utils/helpers/helper_functions.dart';
import 'package:talk_nest/view/onBoarding/onboarding_desine_page.dart';
import 'package:talk_nest/view/onBoarding/onboarding_dot_navigation.dart';
import 'package:talk_nest/view/onBoarding/onboarding_getstarted.dart';
import 'package:talk_nest/view/onBoarding/onboarding_skip.dart';
import '../../utils/constants/images.dart';
import '../../view_model/getx/onboarding_controller/onboarding_controller.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());
    final sizes = MediaQuery.of(context).size;
    final dark = AppHelperFunctions.isDarkMode(context);

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: [
              OnBoardingPage(
                title: AppString.onboardingTitlePage1,
                subTitle: AppString.onboardingSubTitlePage1,
                onBoardingImage: AppImage.onboardingImagePage1,
              ),
              OnBoardingPage(
                title: AppString.onboardingTitlePage2,
                subTitle: AppString.onboardingSubTitlePage2,
                onBoardingImage: AppImage.onboardingImagePage2,
              ),
              OnBoardingPage(
                title: AppString.onboardingTitlePage3,
                subTitle: AppString.onboardingSubTitlePage3,
                onBoardingImage: AppImage.onboardingImagePage3,
              ),
              OnBoardingPage(
                title: AppString.onboardingTitlePage4,
                subTitle: AppString.onboardingSubTitlePage4,
                onBoardingImage: AppImage.onboardingImagePage4,
              )
            ],
          ),
          OnBoardSkip(),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ClipPath(
                clipper: AquaBlueClipper(),
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.55,
                    color: dark ? AppColors.black700 : AppColors.blue100),
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ClipPath(
                clipper: WhiteCurveClipper(),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.50,
                  color: dark ? AppColors.blue900 : AppColors.lightBlue,
                ),
              ),
            ),
          ),
          OnBoardingDotNavigation(),
          OnboardingGetstarted()
        ],
      ),
    );
  }
}

class AquaBlueClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.25);
    path.quadraticBezierTo(
        size.width * 0.5, size.height * 0.50, size.width, size.height * 0.25);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WhiteCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.35);
    path.quadraticBezierTo(
        size.width * 0.5, size.height * 0.60, size.width, size.height * 0.35);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
