import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/features/auth/controllers/auth_controller..dart';
import 'package:template/features/auth/screens/auth_background_screen.dart';
import 'package:template/features/auth/widgets/reset_password_container.dart';

class ResetPasswordScreen extends GetView<AuthController> {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthBackgroundScreen(
      child: ResetPasswordContainer(controller: controller),
    );
  }
}
