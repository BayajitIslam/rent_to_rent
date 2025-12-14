import 'dart:async';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:template/core/utils/log.dart';
import 'package:template/routes/routes_name.dart';

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
    Timer.periodic(Duration(milliseconds: 500), (Timer t) {
      if (opacity.value < 1) {
        opacity.value += 0.25;
      } else {
        t.cancel();
      }
    });

    // Navigate after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      _checkAndNavigate();
    });
  }

  Future<void> _checkAndNavigate() async {
    // Prevent multiple navigation
    if (_hasNavigated) return;
    _hasNavigated = true;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Check Onboarding Completed
      bool onboardingCompleted = prefs.getBool("onboarding_completed") ?? false;

      // Check Login
      bool loginCompleted = prefs.getBool("login_completed") ?? false;

      // Check Plan Active
      bool isPlanActive = prefs.getBool('plan_active') ?? false;

      Console.green("Onboarding: $onboardingCompleted");
      Console.green("Login: $loginCompleted");
      Console.green("Plan Active: $isPlanActive");

      if (!onboardingCompleted) {
        Get.offAllNamed(RoutesName.onboarding);
      } else if (!loginCompleted) {
        Get.offAllNamed(RoutesName.signUp);
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
