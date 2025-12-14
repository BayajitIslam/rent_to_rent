import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:template/core/constants/app_string.dart';
import 'package:template/core/constants/image_const.dart';
import 'package:template/routes/routes_name.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  final List<OnboardingData> pages = [
    OnboardingData(
      title: AppString.onboarding1Title,
      description: AppString.onboarding1SubTitle,
      imagePath: AppImage.onboarding1,
    ),
    OnboardingData(
      title: AppString.onboarding2Title,
      description: AppString.onboarding2SubTitle,
      imagePath: AppImage.onboarding2,
    ),
    OnboardingData(
      title: AppString.onboarding3Title,
      description: AppString.onboarding3SubTitle,
      imagePath: AppImage.onboarding3,
    ),
  ];

  void onPageChanged(int page) {
    currentPage.value = page;
  }

  void nextPage() {
    if (currentPage.value < pages.length - 1) {
      pageController.animateToPage(
        currentPage.value + 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      finishOnboarding();
    }
  }

  void skipOnboarding() {
    finishOnboarding();
  }

  Future<void> finishOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    Get.offAndToNamed(RoutesName.signUp);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

class OnboardingData {
  final String title;
  final String description;
  final String imagePath;
  final double imageheight;

  OnboardingData({
    required this.title,
    required this.description,
    required this.imagePath,
    this.imageheight = 700,
  });
}
