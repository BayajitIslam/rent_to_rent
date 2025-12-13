import 'package:get/get.dart';
import 'package:template/features/splash_screen/controllers/onboarding_controller.dart';


class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OnboardingController(), fenix: true);
  }
}
