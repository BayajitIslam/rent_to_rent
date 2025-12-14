import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/features/auth/controllers/otp_controller.dart';
import 'package:template/features/auth/screens/auth_background_screen.dart';
import 'package:template/features/auth/widgets/verifycode_container.dart';

class VerifyCodeScreen extends GetView<OTPController> {
  const VerifyCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthBackgroundScreen(
      child: VerifyCodeContainer(controller: controller),
    );
  }
}
