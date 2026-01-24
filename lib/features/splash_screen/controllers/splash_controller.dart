import 'dart:async';

import 'package:get/get.dart';
import 'package:rent2rent/core/services/local_storage/storage_service.dart';
import 'package:rent2rent/core/utils/log.dart';
import 'package:rent2rent/routes/routes_name.dart';

class SplashController extends GetxController {
  Timer? timer;
  var opacity = 0.0.obs;
  bool _hasNavigated = false;

  @override
  void onInit() {
    super.onInit();
    _startAnimation();
  }

  void _startAnimation() {
    // Fade in animation
    Timer.periodic(Duration(milliseconds: 0), (Timer t) {
      if (opacity.value < 1) {
        opacity.value += 0.25;
      } else {
        t.cancel();
      }
    });

    // Navigate after 3 seconds
    Future.delayed(Duration(seconds: 1), () {
      _checkAndNavigate();
    });
  }

  Future<void> _checkAndNavigate() async {
    // Prevent multiple navigation
    if (_hasNavigated) return;
    _hasNavigated = true;

    try {
      // Check Onboarding Completed
      bool onboardingCompleted = await StorageService.getOnboardingCompleted();

      // Check Login
      bool loginCompleted = await StorageService.getIsLoggedIn();

      // Check Plan Active
      bool isPlanActive = await StorageService.getIsPremium();

      Console.green("Onboarding: $onboardingCompleted");
      Console.green("Login: $loginCompleted");
      Console.green("Plan Active: $isPlanActive");

      if (!onboardingCompleted) {
        Get.offAllNamed(RoutesName.onboarding);
      } else if (!loginCompleted) {
        Get.offAllNamed(RoutesName.login);
      } else if (!isPlanActive) {
        Get.offAllNamed(RoutesName.getPremiumScreen);
      } else {
        Get.offAllNamed(RoutesName.home);
      }
    } catch (e) {
      Console.red("Splash Error: $e");
      // Fallback to onboarding on error
      Get.offAllNamed(RoutesName.onboarding);
    }
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
