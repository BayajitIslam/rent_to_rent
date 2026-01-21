import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rent2rent/core/themes/themes.dart';
import 'package:rent2rent/features/home/controllers/navigation_controller.dart';
import 'package:rent2rent/routes/app_routes.dart';
import 'package:rent2rent/routes/routes_name.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final NavigationController navigationController = Get.put(
    NavigationController(),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(440, 966),
      minTextAdapt: true,
      builder: (context, child) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: MyAppThemes.lightThemes,
        themeMode: ThemeMode.system,
        initialRoute: RoutesName.splash,
        getPages: AppRoutes.pages,
      ),
      child: SizedBox(),
    );
  }
}
