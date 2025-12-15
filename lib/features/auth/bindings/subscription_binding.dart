import 'package:get/get.dart';
import 'package:rent2rent/features/auth/controllers/subscription_controller.dart';

class SubscriptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SubscriptionController(), fenix: true);
  }
}
