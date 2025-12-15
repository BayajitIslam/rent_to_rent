import 'package:get/get.dart';
import 'package:rent2rent/core/utils/log.dart';
import 'package:rent2rent/routes/routes_name.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionController extends GetxController {
  // Selected Plan
  final RxString selectedPlan = 'annual'.obs;

  // Loading State
  final RxBool isLoading = false.obs;

  // Start Free Trial
  Future<void> startFreeTrial() async {
    try {
      isLoading.value = true;

      // API Call (Replace with your actual API / Stripe / RevenueCat)
      // final response = await SubscriptionService.startTrial(
      //   plan: selectedPlan.value,
      // );

      // Mock Response
      await Future.delayed(Duration(seconds: 2));

      // Get.snackbar(
      //   'Success',
      //   'Free trial started successfully!',
      //   backgroundColor: Colors.green,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.BOTTOM,
      // );
      Console.green("Success: Free trial started successfully!");

      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setBool('plan_active', true);
      Console.green("Success: ${prefs.getBool("plan_active")}");
      // Navigate to Home
      Get.offAllNamed(RoutesName.home);
    } catch (e) {
      // Get.snackbar(
      //   'Error',
      //   'Failed to start trial. Please try again.',
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.BOTTOM,
      // );
      Console.red("Error: Failed to start trial. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  // Get Selected Plan Price
  String getSelectedPlanPrice() {
    return selectedPlan.value == 'monthly' ? '\$9.00' : '\$7.99/month';
  }

  // Get Selected Plan Trial Days
  int getTrialDays() {
    return selectedPlan.value == 'monthly' ? 7 : 30;
  }
}
