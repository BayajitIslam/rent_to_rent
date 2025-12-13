import 'package:get/get_navigation/get_navigation.dart';
import 'package:template/features/auth/bindings/auth_binding.dart';
import 'package:template/features/auth/screens/sign_in_screen.dart';
import 'package:template/features/auth/screens/sign_up_screen.dart';
import 'package:template/features/home/bindings/home_binding.dart';
import 'package:template/features/home/screens/home_screens.dart';
import 'package:template/features/splash_screen/bindings/onboarding_binding.dart';
import 'package:template/features/splash_screen/bindings/splash_binding.dart';
import 'package:template/features/splash_screen/screens/onboarding_screen.dart';
import 'package:template/features/splash_screen/screens/splash_screen.dart';
import 'package:template/routes/routes_name.dart';

class AppRoutes {
  static List<GetPage> pages = [
    //<=============================== Splash Screen ==================================>
    GetPage(
      name: RoutesName.onboarding,
      page: () => OnboardingScreen(),
      transition: Transition.noTransition,
      binding: OnboardingBinding(),
    ),

    GetPage(
      name: RoutesName.splash,
      page: () => SplashScreen(),
      transition: Transition.noTransition,
      binding: SplashBinding(),
    ),
    //<=============================== Main Screen ==================================>
    GetPage(
      name: RoutesName.home,
      page: () => HomeScreen(),
      transition: Transition.rightToLeft,
      binding: HomeBinding(),
    ),
    //<=============================== Auth Screen ==================================>
    GetPage(
      name: RoutesName.login,
      page: () => SignInScreen(),
      transition: Transition.rightToLeft,
      binding: AuthBinding(),
    ),
    GetPage(
      name: RoutesName.signUp,
      page: () => SignUpScreen(),
      transition: Transition.rightToLeft,
      binding: AuthBinding(),
    ),
  ];
}
