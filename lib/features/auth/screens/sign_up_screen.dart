import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/constants/app_string.dart';
import 'package:rent2rent/features/auth/controllers/auth_controller.dart';
import 'package:rent2rent/features/auth/screens/auth_background_screen.dart';
import 'package:rent2rent/features/auth/widgets/signup_container.dart';
import 'package:rent2rent/routes/routes_name.dart';

class SignUpScreen extends GetView<AuthController> {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthBackgroundScreen(
      bottomEnable: true,
      bottomText: AppString.alreadyHaveAnAccount,
      bottomTextButton: AppString.signIn,
      onTap: () => Get.toNamed(RoutesName.login),
      child: SignUpContainer(controller: controller),
    );
  }
}
