import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/features/home/controllers/home_controller.dart';
import 'package:template/features/home/screens/main_layout.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(child: Container(child: Text("Home")));
  }
}
