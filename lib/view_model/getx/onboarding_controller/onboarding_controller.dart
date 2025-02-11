import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:talk_nest/view/auth/sign_in_page.dart';

class OnboardingController extends GetxController {
  static OnboardingController get instance => Get.find();

  final pageController = PageController();
  Rx<int> currentPageIndicator = 0.obs;

  RxBool isGetStarted = false.obs;

  @override
  void onInit() {
    super.onInit();
    ever(currentPageIndicator, (int index) {
      isGetStarted.value = index == 3;
    });
  }

  void updatePageIndicator(int index) => currentPageIndicator.value = index;

  void dotNavigationClick(index) {
    currentPageIndicator.value = index;
    pageController.jumpToPage(index);
  }

  void nextPage() {
    if (currentPageIndicator.value == 3) {
      Get.offAll(SignInPage());
    } else {
      int page = currentPageIndicator.value + 1;
      pageController.jumpToPage(page);
    }
  }

  void skipPage() {
    currentPageIndicator.value = 3;
    pageController.animateToPage(
      3,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
