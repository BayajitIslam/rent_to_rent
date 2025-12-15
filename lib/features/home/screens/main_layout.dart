import 'package:flutter/material.dart';
import 'package:template/features/home/widgets/custom_bottom_nav_bar.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final bool showBottomNav;

  const MainLayout({super.key, required this.child, this.showBottomNav = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          // image: DecorationImage(
          //   image: AssetImage("assets/images/bg.png"),
          //   fit: BoxFit.cover,
          // ),
        ),
        child: child,
      ),
      bottomNavigationBar: showBottomNav ? CustomBottomNavBar() : null,
    );
  }
}
