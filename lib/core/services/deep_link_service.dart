import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/utils/log.dart';
import 'package:rent2rent/features/auth/controllers/subscription_controller.dart';
import 'package:rent2rent/routes/routes_name.dart';

class DeepLinkService {
  static final AppLinks _appLinks = AppLinks();
  static bool _isInitialized = false;

  static Future<void> init() async {
    if (_isInitialized) return;
    _isInitialized = true;

    // Handle initial link (app opened from link)
    try {
      final initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        _handleDeepLink(initialLink);
      }
    } catch (e) {
      Console.red('Error getting initial link: $e');
    }

    // Handle links while app is running
    _appLinks.uriLinkStream.listen((Uri uri) {
      _handleDeepLink(uri);
    });

    Console.green('DeepLinkService initialized');
  }

  static void _handleDeepLink(Uri uri) {
    Console.blue('Deep link received: $uri');

    // Handle https://www.orderwithpluto.com/
    if (uri.host == 'www.orderwithpluto.com' || uri.host == 'orderwithpluto.com') {
      Console.green('Payment successful - verifying...');
      _verifyPayment();
    }
  }

  static void _verifyPayment() async {
    // Small delay to ensure controller is ready
    await Future.delayed(Duration(milliseconds: 500));

    try {
      if (Get.isRegistered<SubscriptionController>()) {
        final controller = Get.find<SubscriptionController>();
        controller.verifySubscriptionStatus();
      } else {
        // If controller not found, navigate to home directly
        Console.yellow('Controller not found, navigating to home');
        Get.offAllNamed(RoutesName.home);
      }
    } catch (e) {
      Console.red('Error verifying payment: $e');
    }
  }
}