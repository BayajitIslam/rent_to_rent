import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/features/auth/controllers/auth_controller..dart';

class SignInScreen extends GetView<AuthController> {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Sign in")));
  }
}
