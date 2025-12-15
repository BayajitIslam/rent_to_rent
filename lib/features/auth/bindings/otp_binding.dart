import 'package:get/get.dart';
import 'package:rent2rent/features/auth/controllers/otp_controller.dart';

class OTPBinding extends Bindings {
  @override
  void dependencies() {
    // Get arguments from route
    final args = Get.arguments as Map<String, dynamic>?;

    Get.lazyPut<OTPController>(
      () => OTPController(
        verificationType: args?['verificationType'] ?? 'forgot_password',
        email: args?['email'],
      ),
    );
  }
}
