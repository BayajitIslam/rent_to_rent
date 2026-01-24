import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/constants/api_endpoints.dart';
import 'package:rent2rent/core/services/api_service.dart';
import 'package:rent2rent/core/services/local_storage/storage_service.dart';
import 'package:rent2rent/core/utils/log.dart';
import 'package:rent2rent/features/auth/models/user_model.dart';
import 'package:rent2rent/features/home/widgets/custome_snackbar.dart';
import 'package:rent2rent/routes/routes_name.dart';

class AuthController extends GetxController {
  // Sign Up Form Controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailPhoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Sign In Form Controllers
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();
  // Variables
  final RxBool rememberMe = false.obs;

  // Forgot Password Controller
  final forgotPasswordEmailController = TextEditingController();

  // Reset Password Controllers
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  // Password Visibility
  final RxBool isNewPasswordVisible = false.obs;
  final RxBool isConfirmNewPasswordVisible = false.obs;
  final RxBool isIndividual = true.obs;
  final RxBool obscurePassword = true.obs;

  // Observable States
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  //Error Message
  final RxString errorMessageSignIn = ''.obs;
  final RxString errorMessageSignUp = ''.obs;
  final RxString errorMessageForgotPassword = ''.obs;

  // Error Message for Reset Password
  final RxString errorMessageResetPassword = ''.obs;

  // Toggle Password Visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  // Toggle Password Visibility
  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  void toggleConfirmNewPasswordVisibility() {
    isConfirmNewPasswordVisible.value = !isConfirmNewPasswordVisible.value;
  }

  // Sign Up
  Future<void> signUp() async {
    if (!_validateSignUpForm()) return;

    final userData = {
      'user_type': isIndividual.value ? 'individuals' : 'company',
      'full_name': fullNameController.text.trim(),
      'email': emailPhoneController.text.trim(),
      'password': passwordController.text,
    };
    try {
      isLoading.value = true;

      final response = await ApiService.post(
        ApiEndpoints.register,
        body: userData,
      );

      if (response.success || response.statusCode == 201) {
        //debug info
        Console.success("Account created successfully!");

        //get data from response
        final Map<String, dynamic> data = response.data;
        final String message = data['message'];
        Console.success(message);
        // Navigate to veryfy
        Get.toNamed(
          RoutesName.verifyCodeScreen,
          arguments: {
            'verificationType': 'signup',
            'email': emailPhoneController.text.trim(),
          },
        );
      } else if (response.statusCode == 400) {
        //get data from response
        final data = response.data;
        final String message = data['email']['message'];
        Console.info(message);
        if (data['email']['status'] == 'resend_activation') {
          CustomeSnackBar.success(message);
          // Navigate to veryfy
          Get.toNamed(
            RoutesName.verifyCodeScreen,
            arguments: {
              'verificationType': 'signup',
              'email': emailPhoneController.text.trim(),
            },
          );
        } else {
          CustomeSnackBar.error(message);
        }
      }
    } catch (e) {
      //debug info
      Console.red("Error: ${e.toString()}");
      CustomeSnackBar.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Sign In
  Future<void> signIn() async {
    if (!_validateSignInForm()) {
      Console.red(errorMessageSignIn.value);
      CustomeSnackBar.error(errorMessageSignIn.value);
      return;
    }

    final userData = {
      'email': loginEmailController.text.trim(),
      'password': loginPasswordController.text,
    };
    try {
      isLoading.value = true;

      final response = await ApiService.post(
        ApiEndpoints.login,
        body: userData,
      );

      if (response.success || response.statusCode == 200) {
        //get data from response
        final Map<String, dynamic> data = response.data;
        final String message = data['message'];
        StorageService.setRefreshToken(data['refresh']);
        StorageService.setAccessToken(data['access']);
        StorageService.setUserEmail(data['user_details']['email']);
        StorageService.setUserName(data['user_details']['full_name']);
        StorageService.setUserType(data['user_details']['user_type']);
        StorageService.setIsLoggedIn(true);
        StorageService.setOnboardingCompleted(true);

        //set for only demo no incoming data from backend
        final isPremium = await StorageService.getIsPremium();
        if (!isPremium) {
          StorageService.setIsPremium(false);
        }
        Console.success(message);
        // Navigate to veryfy

        bool? isplanActive = await StorageService.getIsPremium();
        // Navigate to Home
        if (!isplanActive) {
          Get.offAllNamed(RoutesName.getPremiumScreen);
        } else {
          Get.offAllNamed(RoutesName.home);
        }
      } else if (response.statusCode == 401) {
        //get data from response
        CustomeSnackBar.error(response.data['message']);
      }
    } catch (e) {
      Console.red("Error: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  // Send Password Reset Email
  Future<void> sendPasswordResetEmail() async {
    errorMessageForgotPassword.value = '';

    // Validation
    if (forgotPasswordEmailController.text.trim().isEmpty) {
      CustomeSnackBar.error('Please enter your email');
      errorMessageForgotPassword.value = 'Please enter your email';
      Console.red(errorMessageForgotPassword.value);
      return;
    }

    if (!GetUtils.isEmail(forgotPasswordEmailController.text.trim())) {
      CustomeSnackBar.error('Please enter a valid email');
      errorMessageForgotPassword.value = 'Please enter a valid email';
      Console.red(errorMessageForgotPassword.value);
      return;
    }

    try {
      isLoading.value = true;

      final userData = {'email': forgotPasswordEmailController.text.trim()};
      final response = await ApiService.post(
        ApiEndpoints.forgetPasswordSendOtp,
        body: userData,
      );
      if (response.success || response.statusCode == 200) {
        //get data from response
        final Map<String, dynamic> data = response.data;
        final String message = data['message'];
        Console.success(message);
        // Navigate to VerifyCode with arguments
        Get.toNamed(
          RoutesName.verifyCodeScreen,
          arguments: {
            'verificationType': 'forgot_password',
            'email': forgotPasswordEmailController.text.trim(),
          },
        );
      } else if (response.statusCode == 400) {
        //get data from response
        final data = response.data;
        final String message = data['email']['message'];
        Console.info(message);
        CustomeSnackBar.success(message);
      } else {
        CustomeSnackBar.error('Something went wrong');
      }
    } catch (e) {
      errorMessageForgotPassword.value =
          'Failed to send reset link. Please try again.';
      Console.red(
        "Error: ${e.toString()} - ${errorMessageForgotPassword.value}",
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Reset Password
  Future<void> resetPassword() async {
    errorMessageResetPassword.value = '';

    // Validation
    if (newPasswordController.text.isEmpty) {
      CustomeSnackBar.error('Please enter your new password');
      errorMessageResetPassword.value = 'Please enter your new password';
      Console.red("Error: Please enter your new password");
      return;
    }

    if (newPasswordController.text.length < 6) {
      CustomeSnackBar.error('Password must be at least 6 characters');
      errorMessageResetPassword.value =
          'Password must be at least 6 characters';
      Console.red("Error: Password must be at least 6 characters");
      return;
    }

    if (confirmNewPasswordController.text.isEmpty) {
      CustomeSnackBar.error('Please confirm your password');
      errorMessageResetPassword.value = 'Please confirm your password';
      Console.red("Please confirm your password");
      return;
    }

    if (newPasswordController.text != confirmNewPasswordController.text) {
      CustomeSnackBar.error('Passwords do not match');
      errorMessageResetPassword.value = 'Passwords do not match';
      Console.red("Error: Passwords do not match");
      return;
    }

    try {
      isLoading.value = true;

      final userData = {
        'email': Get.arguments['email'],
        'password': newPasswordController.text,
        'confirm_password': confirmNewPasswordController.text,
      };
      final response = await ApiService.post(
        ApiEndpoints.resetPassword,
        body: userData,
      );
      if (response.success || response.statusCode == 200) {
        //get data from response
        final Map<String, dynamic> data = response.data;
        final String message = data['message'];
        Console.success(message);
        // Navigate to VerifyCode with arguments
        Get.toNamed(RoutesName.login);
      } else if (response.statusCode == 400) {
        //get data from response
        final data = response.data;
        final String message = data['message'];
        Console.info(message);
        CustomeSnackBar.success(message);
      } else {
        CustomeSnackBar.error('Something went wrong');
      }

      // Clear fields
      newPasswordController.clear();
      confirmNewPasswordController.clear();
    } catch (e) {
      CustomeSnackBar.success('Failed to reset password. Please try again.');
      errorMessageResetPassword.value =
          'Failed to reset password. Please try again.';
      Console.red(
        "Error: ${e.toString()} - ${errorMessageForgotPassword.value}",
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    StorageService.clearAll();
    Get.offAllNamed(RoutesName.login);
  }

  // Validate Sign Up Form
  bool _validateSignUpForm() {
    if (fullNameController.text.trim().isEmpty) {
      errorMessageSignUp.value = 'Please enter your full name';
      CustomeSnackBar.error(errorMessageSignUp.value);
      Console.error(errorMessageSignUp.value);
      return false;
    }
    if (emailPhoneController.text.trim().isEmpty) {
      errorMessageSignUp.value = 'Please enter your email';
      CustomeSnackBar.error(errorMessageSignUp.value);
      Console.error(errorMessageSignUp.value);
      return false;
    }
    if (!GetUtils.isEmail(emailPhoneController.text.trim())) {
      errorMessageSignUp.value = 'Please enter a valid email';
      CustomeSnackBar.error(errorMessageSignUp.value);
      Console.error(errorMessageSignUp.value);
      return false;
    }
    if (passwordController.text.length < 6) {
      errorMessageSignUp.value = 'Password must be at least 6 characters';
      CustomeSnackBar.error(errorMessageSignUp.value);
      Console.error(errorMessageSignUp.value);
      return false;
    }

    return true;
  }

  // Validate Sign In Form
  bool _validateSignInForm() {
    if (loginEmailController.text.trim().isEmpty) {
      errorMessageSignIn.value = 'Please enter your email';

      return false;
    }
    if (!GetUtils.isEmail(loginEmailController.text.trim())) {
      errorMessageSignIn.value = 'Please enter a valid email';
      debugPrint(errorMessageSignIn.value);
      return false;
    }
    if (loginPasswordController.text.isEmpty) {
      errorMessageSignIn.value = 'Please enter your password';

      return false;
    }
    if (rememberMe.value) {}
    return true;
  }
}
