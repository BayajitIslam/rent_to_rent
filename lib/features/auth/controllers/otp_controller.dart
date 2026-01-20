import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/constants/api_endpoints.dart';
import 'package:rent2rent/core/services/api_service.dart';
import 'package:rent2rent/core/utils/log.dart';
import 'package:rent2rent/features/home/widgets/custome_snackbar.dart';
import 'package:rent2rent/routes/routes_name.dart';

class OTPController extends GetxController {
  final String verificationType; // 'signup' or 'forgot_password'
  final String? email;

  OTPController({required this.verificationType, this.email});

  // OTP Controllers for each box (6 digits)
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  // Focus Nodes for each box (6 digits)
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  // Observable States
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt remainingTime = 120.obs; // 2 minutes in seconds
  final RxBool canResend = false.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  // Start Countdown Timer
  void startTimer() {
    remainingTime.value = 120;
    canResend.value = false;

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime.value > 0) {
        remainingTime.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  // Format Time (MM:SS)
  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString()}:${secs.toString().padLeft(2, '0')}';
  }

  // Get OTP Code
  String getOTPCode() {
    return otpControllers.map((controller) => controller.text).join();
  }

  // Verify OTP
  Future<void> verifyOTP() async {
    errorMessage.value = '';

    String otp = getOTPCode().toString();

    // Validation (6 digits now)
    if (otp.length != 6) {
      errorMessage.value = 'Please enter complete 6 digit code';
      CustomeSnackBar.error(errorMessage.value);
      Console.red(errorMessage.value);
      return;
    }

    final endpoint = verificationType == 'signup'
        ? ApiEndpoints.registerActivate
        : ApiEndpoints.forgotPasswordVerify;

    try {
      isLoading.value = true;

      final response = await ApiService.post(
        endpoint,
        body: {'email': email, 'code': otp},
      );

      if (response.success || response.statusCode == 200) {
        String successMessage = response.data['message'];

        // Navigate based on verification type
        if (verificationType == 'signup') {
          // Sign Up Flow: Go to Login
          CustomeSnackBar.success(successMessage);
          Console.magenta(successMessage);
          Get.offAllNamed(RoutesName.login);
        } else if (verificationType == 'forgot_password') {
          // Forgot Password Flow: Go to Reset Password
          CustomeSnackBar.success(successMessage);
          Console.magenta(successMessage);
          Get.offAllNamed(
            RoutesName.resetPasswordScreen,
            arguments: {'email': email},
          );
        }
      } else if (response.statusCode == 400) {
        Console.info("Response: ${response.data}");
        final data = response.data;

        // Handle both String and List types for error messages
        String message;
        if (data['message'] is List) {
          // If message is a list, join all error messages
          message = (data['message'] as List).join(', ');
        } else if (data['message'] is String) {
          // If message is a string, use it directly
          message = data['message'];
        } else {
          // Fallback message
          message = 'Verification failed. Please try again.';
        }

        Console.info(message);
        CustomeSnackBar.error(message);
      }
    } catch (e) {
      errorMessage.value = 'Verification failed. Please try again.';
      CustomeSnackBar.error('Verification failed. Please try again.');
      Console.red(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Resend OTP
  Future<void> resendOTP() async {
    if (!canResend.value) return;

    try {
      // API Call to resend OTP
      // await ApiService.resendOTP(
      //   email: email,
      //   type: verificationType,
      // );

      // Mock Response
      await Future.delayed(Duration(seconds: 1));

      // Get.snackbar(
      //   'Success',
      //   'OTP has been resent to your email',
      //   backgroundColor: Colors.green,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.BOTTOM,
      // );

      Console.green("Success: OTP has been resent to your email");

      // Restart timer
      startTimer();

      // Clear OTP fields
      clearOTP();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to resend OTP. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      Console.red("Error: Failed to resend OTP. Please try again.");
    }
  }

  // Clear OTP fields
  void clearOTP() {
    for (var controller in otpControllers) {
      controller.clear();
    }
    // Focus on first field
    focusNodes[0].requestFocus();
  }

  @override
  void onClose() {
    _timer?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.onClose();
  }
}
