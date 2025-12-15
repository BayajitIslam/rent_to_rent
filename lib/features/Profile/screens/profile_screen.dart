import 'package:flutter/material.dart';
import 'package:rent2rent/features/home/screens/main_layout.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(child: Center(child: Text("Prfile")));
  }
}
