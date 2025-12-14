import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_string.dart';
import 'package:template/features/auth/controllers/auth_controller..dart';
import 'package:template/features/auth/screens/auth_background_screen.dart';
import 'package:template/features/auth/widgets/signin_container.dart';
import 'package:template/routes/routes_name.dart';

class SignInScreen extends GetView<AuthController> {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthBackgroundScreen(
      bottomEnable: true,
      bottomText: AppString.dontHaveAn,
      bottomTextButton: AppString.signup,
      onTap: () => Get.toNamed(RoutesName.signUp),
      child: SigninContainer(controller: controller),
    );
  }
}
