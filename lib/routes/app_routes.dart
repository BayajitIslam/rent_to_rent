import 'package:get/get_navigation/get_navigation.dart';
import 'package:template/features/Contract%20Analysis/screens/contract_analysis_screen.dart';
import 'package:template/features/Create%20Contract/screens/create_contract_screen.dart';
import 'package:template/features/Field%20Agent%20Communication/bindings/agent_reply_binding.dart';
import 'package:template/features/Field%20Agent%20Communication/bindings/field_agent_binding.dart';
import 'package:template/features/Field%20Agent%20Communication/screens/agent_reply_screen.dart';
import 'package:template/features/Field%20Agent%20Communication/screens/field_agent_communication_screen.dart';
import 'package:template/features/Location%20Suitability/screens/location_suitability_screen.dart';
import 'package:template/features/Profile/screens/profile_screen.dart';
import 'package:template/features/auth/bindings/auth_binding.dart';
import 'package:template/features/auth/bindings/otp_binding.dart';
import 'package:template/features/auth/bindings/subscription_binding.dart';
import 'package:template/features/auth/screens/forgot_password_screen.dart';
import 'package:template/features/auth/screens/get_premium_screen.dart';
import 'package:template/features/auth/screens/reset_password_screen.dart';
import 'package:template/features/auth/screens/reset_succesfull_screen.dart';
import 'package:template/features/auth/screens/sign_in_screen.dart';
import 'package:template/features/auth/screens/sign_up_screen.dart';
import 'package:template/features/auth/screens/verify_code_screen.dart';
import 'package:template/features/home/bindings/home_binding.dart';
import 'package:template/features/home/bindings/navigation_binding.dart';
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
      page: () => DashboardScreen(),
      transition: Transition.noTransition,
      bindings: [HomeBinding(), NavigationBinding()],
    ),
    GetPage(
      name: RoutesName.profile,
      page: () => ProfileScreen(),
      transition: Transition.noTransition,
      bindings: [NavigationBinding()],
    ),

    GetPage(
      name: RoutesName.createContractScreen,
      page: () => CreateContractScreen(),
      transition: Transition.noTransition,
      bindings: [NavigationBinding()],
    ),

    GetPage(
      name: RoutesName.locationSuitabilityScreen,
      page: () => LocationSuitabilityScreen(),
      transition: Transition.noTransition,
      bindings: [NavigationBinding()],
    ),
    GetPage(
      name: RoutesName.contractAnalysisScreen,
      page: () => ContractAnalysisScreen(),
      transition: Transition.noTransition,
      bindings: [NavigationBinding()],
    ),
    GetPage(
      name: RoutesName.fieldAgentScreen,
      page: () => FieldAgentCommunicationScreen(),
      transition: Transition.noTransition,
      bindings: [NavigationBinding(), FieldAgentBinding()],
    ),
    GetPage(
      name: RoutesName.agentReplyScreen,
      page: () => AgentReplyScreen(),
      transition: Transition.noTransition,
      bindings: [NavigationBinding(), AgentReplyBinding()],
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
    GetPage(
      name: RoutesName.forgotPassword,
      page: () => ForgotPasswordScreen(),
      transition: Transition.rightToLeft,
      binding: AuthBinding(),
    ),
    GetPage(
      name: RoutesName.verifyCodeScreen,
      page: () => VerifyCodeScreen(),
      transition: Transition.rightToLeft,
      binding: OTPBinding(),
    ),
    GetPage(
      name: RoutesName.resetPasswordScreen,
      page: () => ResetPasswordScreen(),
      transition: Transition.rightToLeft,
      binding: AuthBinding(),
    ),
    GetPage(
      name: RoutesName.resetSuccessfullScreen,
      page: () => ResetSuccesfullScreen(),
      transition: Transition.rightToLeft,
      // binding: AuthBinding(),
    ),
    GetPage(
      name: RoutesName.getPremiumScreen,
      page: () => GetPremiumScreen(),
      transition: Transition.rightToLeft,
      binding: SubscriptionBinding(),
    ),
  ];
}
