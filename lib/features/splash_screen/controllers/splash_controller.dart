import 'dart:async';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:template/routes/routes_name.dart';

class SplashController extends GetxController {
  Timer? timer;
  var opacity = 0.0.obs;

  @override
  void onInit() {
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) {
      if (opacity.value != 1) {
        opacity.value += 0.5;
      }

      Future.delayed(const Duration(seconds: 3), () async {
        //SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();

        //Check Onboarding Completed
        bool? onboardingCompleted =
            prefs.getBool("onboarding_completed") ?? false;

        //Check Login
        bool? login = prefs.getBool("login_completed") ?? false;

        if (!onboardingCompleted) {
          Get.toNamed(RoutesName.onboarding);
        } else if (!login) {
          Get.toNamed(RoutesName.login);
        } else {
          Get.toNamed(RoutesName.home);
        }
      });
    });
    super.onInit();
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
