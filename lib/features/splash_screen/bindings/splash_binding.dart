import 'package:get/get.dart';
import 'package:rent2rent/features/splash_screen/controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController(), fenix: true);
  }
}
