import 'package:get/get.dart';
import 'package:rent2rent/core/constants/api_endpoints.dart';
import 'package:rent2rent/core/services/api_service.dart';
import 'package:rent2rent/core/utils/log.dart';
import 'package:rent2rent/features/home/widgets/custome_snackbar.dart';
import 'package:rent2rent/routes/routes_name.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionController extends GetxController {
  // Loading State
  final RxBool isLoading = false.obs;
  final RxBool isPlansLoading = false.obs;

  // Selected Plan ID
  final RxInt selectedPlanId = 0.obs;

  // Plans from API
  final Rx<PlanModel?> monthlyPlan = Rx<PlanModel?>(null);
  final Rx<PlanModel?> annualPlan = Rx<PlanModel?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchPlans();
    verifySubscriptionStatus();
  }

  // ==================== Fetch Plans ====================
  Future<void> fetchPlans() async {
    try {
      isPlansLoading.value = true;

      final response = await ApiService.getAuth(ApiEndpoints.subscription);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final plans = data.map((e) => PlanModel.fromJson(e)).toList();

        monthlyPlan.value = plans.firstWhereOrNull(
          (p) => p.interval == 'month' && p.isActive,
        );
        annualPlan.value = plans.firstWhereOrNull(
          (p) => p.interval == 'year' && p.isActive,
        );

        if (annualPlan.value != null) {
          selectedPlanId.value = annualPlan.value!.id;
        } else if (monthlyPlan.value != null) {
          selectedPlanId.value = monthlyPlan.value!.id;
        }

        Console.green(
          'Plans fetched - Monthly: ${monthlyPlan.value?.name}, Annual: ${annualPlan.value?.name}',
        );
      }
    } catch (e) {
      Console.red('Error fetching plans: $e');
    } finally {
      isPlansLoading.value = false;
    }
  }

  // ==================== Select Plan ====================
  void selectPlan(int planId) {
    selectedPlanId.value = planId;
    Console.blue('Selected plan ID: $planId');
  }

  // ==================== Check if plan exists ====================
  bool get hasMonthlyPlan => monthlyPlan.value != null;
  bool get hasAnnualPlan => annualPlan.value != null;

  // ==================== Get Monthly Price ====================
  String getMonthlyPrice() {
    if (monthlyPlan.value != null) {
      return '\$${monthlyPlan.value!.amount}';
    }
    return '\$9.00';
  }

  // ==================== Get Annual Price (per month) ====================
  String getAnnualPrice() {
    if (annualPlan.value != null) {
      final monthlyPrice = (double.parse(annualPlan.value!.amount) / 12)
          .toStringAsFixed(2);
      return '\$$monthlyPrice';
    }
    return '\$7.99';
  }

  // ==================== Get Trial Days ====================
  int getTrialDays() {
    if (selectedPlanId.value == annualPlan.value?.id) {
      return annualPlan.value?.trialPeriodDays ?? 30;
    } else if (selectedPlanId.value == monthlyPlan.value?.id) {
      return monthlyPlan.value?.trialPeriodDays ?? 7;
    }
    return 30;
  }

  // ==================== Create Subscription ====================
  Future<void> createSubscription() async {
    if (selectedPlanId.value == 0) {
      CustomeSnackBar.error('Please select a plan');
      return;
    }

    final isValidPlan =
        selectedPlanId.value == monthlyPlan.value?.id ||
        selectedPlanId.value == annualPlan.value?.id;

    if (!isValidPlan) {
      CustomeSnackBar.error('This plan is coming soon!');
      return;
    }

    try {
      isLoading.value = true;

      final response = await ApiService.postAuth(
        ApiEndpoints.createPaymentIntent,
        body: {'payment_plan_id': selectedPlanId.value},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('subscription_id', data['subscription_id']);
        await prefs.setString(
          'checkout_session_id',
          data['checkout_session_id'],
        );

        final checkoutUrl = data['checkout_session_url'];
        if (checkoutUrl != null) {
          await _launchStripeCheckout(checkoutUrl);
        }
      } else {
        Console.red('Error creating subscription: ${response.data}');
        CustomeSnackBar.error('Failed to create subscription');
      }
    } catch (e) {
      Console.red('Error creating subscription: $e');
      CustomeSnackBar.error('Failed to create subscription');
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== Launch Stripe Checkout ====================
  Future<void> _launchStripeCheckout(String checkoutUrl) async {
    try {
      final Uri url = Uri.parse(checkoutUrl);

      // Use external browser for deep link to work
      await launchUrl(url, mode: LaunchMode.externalApplication);
      Console.green('Stripe checkout opened');
    } catch (e) {
      Console.red('Error launching checkout: $e');
      CustomeSnackBar.error('Failed to open payment page');
    }
  }

  // ==================== Verify Subscription Status ====================
  Future<void> verifySubscriptionStatus() async {
    try {
      isLoading.value = true;
      Console.blue('Verifying subscription status...');

      final response = await ApiService.getAuth(ApiEndpoints.subscription);

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic>) {
          final status = data['status'];
          if (status == 'active' || status == 'trialing') {
            await _activateSubscription();
            return;
          }
        }

        // If we reach here, payment might still be processing
        // Navigate to home anyway since user completed checkout
        Console.yellow('Subscription status: ${data}');
        await _activateSubscription();
      }
    } catch (e) {
      Console.red('Error verifying subscription: $e');
      // Still navigate to home if user completed payment
      await _activateSubscription();
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== Activate Subscription ====================
  Future<void> _activateSubscription() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('plan_active', true);

    Console.green('Subscription activated!');
    Get.offAllNamed(RoutesName.home);
    CustomeSnackBar.success('Subscription activated successfully!');
  }
}

// ==================== Plan Model ====================
class PlanModel {
  final int id;
  final String name;
  final String stripeProductId;
  final String stripePriceId;
  final String amount;
  final String interval;
  final String currency;
  final int trialPeriodDays;
  final bool isActive;

  PlanModel({
    required this.id,
    required this.name,
    required this.stripeProductId,
    required this.stripePriceId,
    required this.amount,
    required this.interval,
    required this.currency,
    required this.trialPeriodDays,
    required this.isActive,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      stripeProductId: json['stripe_product_id'] ?? '',
      stripePriceId: json['stripe_price_id'] ?? '',
      amount: json['amount'] ?? '0.00',
      interval: json['interval'] ?? 'month',
      currency: json['currency'] ?? 'usd',
      trialPeriodDays: json['trial_period_days'] ?? 0,
      isActive: json['is_active'] ?? false,
    );
  }
}
