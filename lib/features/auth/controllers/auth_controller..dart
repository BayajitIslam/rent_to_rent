import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:template/core/utils/log.dart';
import 'package:template/features/auth/models/user_model.dart';
import 'package:template/routes/routes_name.dart';

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
    //TODO  uncomment This Line After Api Ready
    // if (!_validateSignUpForm()) return;

    try {
      isLoading.value = true;

      // API Call (Replace with your actual API)
      // final response = await ApiService.signUp(
      //   name: nameController.text.trim(),
      //   email: emailController.text.trim(),
      //   password: passwordController.text,
      //   phone: phoneController.text.trim(),
      // );

      // Mock Response (Remove this and use actual API)
      await Future.delayed(Duration(seconds: 2));

      final userData = {
        'id': '123',
        'name': fullNameController.text.trim(),
        'email': emailPhoneController.text.trim(),
        'phone': emailPhoneController.text.trim(),
        'token': 'mock_token_12345',
      };

      final user = UserModel.fromJson(userData);
      currentUser.value = user;

      // Save to SharedPreferences
      await _saveUserData(user);

      // Get.snackbar(
      //   'Success',
      //   'Account created successfully!',
      //   backgroundColor: Colors.green,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.BOTTOM,
      // );
      Console.green("Success: Account created successfully!");
      // Navigate to veryfy
      Get.toNamed(
        RoutesName.verifyCodeScreen,
        arguments: {
          'verificationType': 'signup',
          'email': emailPhoneController.text.trim(),
        },
      );

      Console.magenta(
        "User Type : ${isIndividual.value ? "individual" : "Company"}",
      );
    } catch (e) {
      // Get.snackbar(
      //   'Error',
      //   e.toString(),
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.BOTTOM,
      // );
      Console.red("Error: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  // Sign In
  Future<void> signIn() async {
    //TODO uncomment this line after api intregation
    // if (!_validateSignInForm()) return;

    try {
      isLoading.value = true;

      // API Call (Replace with your actual API)
      // final response = await ApiService.signIn(
      //   email: loginEmailController.text.trim(),
      //   password: loginPasswordController.text,
      // );

      // Mock Response (Remove this and use actual API)
      await Future.delayed(Duration(seconds: 2));

      final userData = {
        'id': '123',
        'name': 'John Doe',
        'email': loginEmailController.text.trim(),
        'token': 'mock_token_12345',
      };

      final user = UserModel.fromJson(userData);
      currentUser.value = user;

      // Save to SharedPreferences
      await _saveUserData(user);

      SharedPreferences prefs = await SharedPreferences.getInstance();

      bool? isplanActive = prefs.getBool('plan_active') ?? false;

      prefs.setBool('login_completed', true);

      // Get.snackbar(
      //   'Success',
      //   'Welcome back!',
      //   backgroundColor: Colors.green,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.BOTTOM,
      // );
      Console.green("Success: Wellcome back!");
      Console.green("Success: $isplanActive");
      // Navigate to Home
      if (!isplanActive) {
        Get.offAllNamed(RoutesName.getPremiumScreen);
      } else {
        Get.offAllNamed(RoutesName.home);
      }
    } catch (e) {
      // Get.snackbar(
      //   'Error',
      //   e.toString(),
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.BOTTOM,
      // );
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
      errorMessageForgotPassword.value = 'Please enter your email';
      Console.red(errorMessageForgotPassword.value);
      return;
    }

    if (!GetUtils.isEmail(forgotPasswordEmailController.text.trim())) {
      errorMessageForgotPassword.value = 'Please enter a valid email';
      Console.red(errorMessageForgotPassword.value);
      return;
    }

    try {
      isLoading.value = true;

      // API Call (Replace with your actual API)
      // final response = await ApiService.forgotPassword(
      //   email: forgotPasswordEmailController.text.trim(),
      // );

      // Mock Response
      await Future.delayed(Duration(seconds: 2));

      // Success
      // Get.snackbar(
      //   'Success',
      //   'Otp has been sent to your email',
      //   backgroundColor: Colors.green,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.BOTTOM,
      //   duration: Duration(seconds: 3),
      // );
      Console.yellow(
        "Otp has been sent to your email ${forgotPasswordEmailController.text.toLowerCase()}",
      );
      // Navigate back to login after 2 seconds
      //TODO Forgot password
      await Future.delayed(Duration(seconds: 2));
      // Navigate to VerifyCode with arguments
      Get.toNamed(
        RoutesName.verifyCodeScreen,
        arguments: {
          'verificationType': 'forgot_password',
          'email': forgotPasswordEmailController.text.trim(),
        },
      );
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
      errorMessageResetPassword.value = 'Please enter your new password';
      Console.red("Error: Please enter your new password");
      return;
    }

    if (newPasswordController.text.length < 6) {
      errorMessageResetPassword.value =
          'Password must be at least 6 characters';
      Console.red("Error: Password must be at least 6 characters");
      return;
    }

    if (confirmNewPasswordController.text.isEmpty) {
      errorMessageResetPassword.value = 'Please confirm your password';
      Console.red("Please confirm your password");
      return;
    }

    if (newPasswordController.text != confirmNewPasswordController.text) {
      errorMessageResetPassword.value = 'Passwords do not match';
      Console.red("Error: Passwords do not match");
      return;
    }

    try {
      isLoading.value = true;

      // API Call (Replace with your actual API)
      // final response = await ApiService.resetPassword(
      //   password: newPasswordController.text,
      // );

      // Mock Response
      await Future.delayed(Duration(seconds: 2));

      // Success
      // Get.snackbar(
      //   'Success',
      //   'Password has been reset successfully!',
      //   backgroundColor: Colors.green,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.BOTTOM,
      // );
      Console.green("Success: Password has been reset successfully!");

      // Clear fields
      newPasswordController.clear();
      confirmNewPasswordController.clear();

      // Navigate to login
      await Future.delayed(Duration(seconds: 1));
      Get.offAllNamed(RoutesName.resetSuccessfullScreen);
    } catch (e) {
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    currentUser.value = null;
    Get.offAllNamed(RoutesName.login);
  }

  // Validate Sign Up Form
  bool _validateSignUpForm() {
    if (emailPhoneController.text.trim().isEmpty) {
      errorMessageSignUp.value = 'Please enter your email';
      debugPrint(errorMessageSignUp.value);
      return false;
    }
    if (!GetUtils.isEmail(emailPhoneController.text.trim())) {
      errorMessageSignUp.value = 'Please enter a valid email';
      debugPrint(errorMessageSignUp.value);
      return false;
    }
    if (passwordController.text.length < 6) {
      errorMessageSignUp.value = 'Password must be at least 6 characters';
      debugPrint(errorMessageSignUp.value);
      return false;
    }

    return true;
  }

  // Validate Sign In Form
  bool _validateSignInForm() {
    if (loginEmailController.text.trim().isEmpty) {
      errorMessageSignIn.value = 'Please enter your email';
      debugPrint(errorMessageSignIn.value);
      return false;
    }
    if (!GetUtils.isEmail(loginEmailController.text.trim())) {
      errorMessageSignIn.value = 'Please enter a valid email';
      debugPrint(errorMessageSignIn.value);
      return false;
    }
    if (loginPasswordController.text.isEmpty) {
      errorMessageSignIn.value = 'Please enter your password';
      debugPrint(errorMessageSignIn.value);
      return false;
    }
    if (rememberMe.value) {
      debugPrint('Remember Me ${rememberMe.value}');
    }
    return true;
  }

  // Save User Data to SharedPreferences
  Future<void> _saveUserData(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', user.id ?? '');
    await prefs.setString('user_name', user.name);
    await prefs.setString('user_email', user.email);
    await prefs.setString('auth_token', user.token ?? '');
    await prefs.setBool('is_logged_in', true);

    //only for ui flow
    await prefs.setBool('plan_active', false);
  }
}
