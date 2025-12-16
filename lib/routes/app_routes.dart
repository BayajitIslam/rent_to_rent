import 'package:get/get_navigation/get_navigation.dart';
import 'package:rent2rent/features/Contract%20Analysis/bindings/contract_analysis_binding.dart';
import 'package:rent2rent/features/Contract%20Analysis/screens/contract_analysis_report_screen.dart.dart';
import 'package:rent2rent/features/Contract%20Analysis/screens/contract_analysis_screen.dart';
import 'package:rent2rent/features/Contract%20Analysis/screens/contract_analyzing_screen.dart';
import 'package:rent2rent/features/Create%20Contract/bindings/contract_bindings.dart';
import 'package:rent2rent/features/Create%20Contract/screens/fill_contract_details_screen.dart';
import 'package:rent2rent/features/Create%20Contract/screens/generate_contract_screen.dart';
import 'package:rent2rent/features/Create%20Contract/screens/select_contract_type_screen.dart';
import 'package:rent2rent/features/Field%20Agent%20Communication/bindings/agent_reply_binding.dart';
import 'package:rent2rent/features/Field%20Agent%20Communication/bindings/field_agent_binding.dart';
import 'package:rent2rent/features/Field%20Agent%20Communication/screens/agent_reply_screen.dart';
import 'package:rent2rent/features/Field%20Agent%20Communication/screens/field_agent_communication_screen.dart';
import 'package:rent2rent/features/Location%20Suitability/bindings/location_suitability_binding.dart';
import 'package:rent2rent/features/Location%20Suitability/screens/location_analyzing_screen.dart';
import 'package:rent2rent/features/Location%20Suitability/screens/location_property_details_screen.dart';
import 'package:rent2rent/features/Location%20Suitability/screens/location_results_screen.dart';
import 'package:rent2rent/features/Location%20Suitability/screens/location_suitability_screen.dart';
import 'package:rent2rent/features/Profile/bindings/profile_binding.dart';
import 'package:rent2rent/features/Profile/screens/about_us_screen.dart';
import 'package:rent2rent/features/Profile/screens/change_password_screen.dart';
import 'package:rent2rent/features/Profile/screens/company_info_screen.dart';
import 'package:rent2rent/features/Profile/screens/guides_screen.dart';
import 'package:rent2rent/features/Profile/screens/help_feedback_screen.dart';
import 'package:rent2rent/features/Profile/screens/personal_info_screen.dart';
import 'package:rent2rent/features/Profile/screens/privacy_policy_screen.dart';
import 'package:rent2rent/features/Profile/screens/profile_screen.dart';
import 'package:rent2rent/features/Profile/screens/saved_files_screen.dart';
import 'package:rent2rent/features/Profile/screens/settings_screen.dart';
import 'package:rent2rent/features/Profile/screens/terms_condition_screen.dart';
import 'package:rent2rent/features/auth/bindings/auth_binding.dart';
import 'package:rent2rent/features/auth/bindings/otp_binding.dart';
import 'package:rent2rent/features/auth/bindings/subscription_binding.dart';
import 'package:rent2rent/features/auth/screens/forgot_password_screen.dart';
import 'package:rent2rent/features/auth/screens/get_premium_screen.dart';
import 'package:rent2rent/features/auth/screens/reset_password_screen.dart';
import 'package:rent2rent/features/auth/screens/reset_succesfull_screen.dart';
import 'package:rent2rent/features/auth/screens/sign_in_screen.dart';
import 'package:rent2rent/features/auth/screens/sign_up_screen.dart';
import 'package:rent2rent/features/auth/screens/verify_code_screen.dart';
import 'package:rent2rent/features/home/bindings/home_binding.dart';
import 'package:rent2rent/features/home/bindings/navigation_binding.dart';
import 'package:rent2rent/features/home/screens/home_screens.dart';
import 'package:rent2rent/features/splash_screen/bindings/onboarding_binding.dart';
import 'package:rent2rent/features/splash_screen/bindings/splash_binding.dart';
import 'package:rent2rent/features/splash_screen/screens/onboarding_screen.dart';
import 'package:rent2rent/features/splash_screen/screens/splash_screen.dart';
import 'package:rent2rent/routes/routes_name.dart';

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
      bindings: [NavigationBinding(), ProfileBinding()],
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
    ),
    GetPage(
      name: RoutesName.getPremiumScreen,
      page: () => GetPremiumScreen(),
      transition: Transition.rightToLeft,
      binding: SubscriptionBinding(),
    ),

    //<=============================== Create Contract Screen ==================================>
    GetPage(
      name: RoutesName.createContractScreen,
      page: () => SelectContractTypeScreen(),
      transition: Transition.noTransition,
      bindings: [NavigationBinding(), ContractBindings()],
    ),
    GetPage(
      name: RoutesName.fillContractDetailsScreen,
      page: () => FillContractDetailsScreen(),
      transition: Transition.rightToLeft,
      binding: ContractBindings(),
    ),

    GetPage(
      name: RoutesName.generateContractScreen,
      page: () => GenerateContractScreen(),
      transition: Transition.rightToLeft,
      binding: ContractBindings(),
    ),

    //<=============================== Contract Anayliyzing Screen ==================================>
    GetPage(
      name: RoutesName.contractAnalysisScreen,
      page: () => ContractAnalysisScreen(),
      transition: Transition.noTransition,
      bindings: [NavigationBinding(), ContractAnalysisBinding()],
    ),
    GetPage(
      name: RoutesName.contractAnalyzingScreen,
      page: () => ContractAnalyzingScreen(),
      transition: Transition.noTransition,
      bindings: [NavigationBinding(), ContractAnalysisBinding()],
    ),
    GetPage(
      name: RoutesName.contractAnalysisReportScreen,
      page: () => ContractAnalysisReportScreen(),
      transition: Transition.noTransition,
      bindings: [NavigationBinding(), ContractAnalysisBinding()],
    ),
    
    //<=============================== Location Suitability Screen ==================================>
    GetPage(
      name: RoutesName.locationSuitabilityScreen,
      page: () => LocationSuitabilityScreen(),
      transition: Transition.noTransition,
      bindings: [NavigationBinding(), LocationSuitabilityBinding()],
    ),
    GetPage(
      name: RoutesName.locationPropertyDetailsScreen,
      page: () => LocationPropertyDetailsScreen(),
      transition: Transition.noTransition,
      bindings: [NavigationBinding(), LocationSuitabilityBinding()],
    ),
    GetPage(
      name: RoutesName.locationAnalyzingScreen,
      page: () => LocationAnalyzingScreen(),
      transition: Transition.noTransition,
      bindings: [NavigationBinding(), LocationSuitabilityBinding()],
    ),
    GetPage(
      name: RoutesName.locationResultsScreen,
      page: () => LocationResultsScreen(),
      transition: Transition.noTransition,
      bindings: [NavigationBinding(), LocationSuitabilityBinding()],
    ),

    //<=============================== Profile Screen ==================================>
    GetPage(
      name: RoutesName.savedFilesScreen,
      page: () => SavedFilesScreen(),
      transition: Transition.rightToLeft,
      bindings: [NavigationBinding(), ProfileBinding()],
    ),
    GetPage(
      name: RoutesName.personalInfoScreen,
      page: () => PersonalInfoScreen(),
      transition: Transition.rightToLeft,
      bindings: [NavigationBinding(), ProfileBinding()],
    ),
    GetPage(
      name: RoutesName.companyInfoScreen,
      page: () => CompanyInfoScreen(),
      transition: Transition.rightToLeft,
      bindings: [NavigationBinding(), ProfileBinding()],
    ),
    GetPage(
      name: RoutesName.helpFeedbackScreen,
      page: () => HelpFeedbackScreen(),
      transition: Transition.rightToLeft,
      bindings: [NavigationBinding(), ProfileBinding()],
    ),
    GetPage(
      name: RoutesName.settingsScreen,
      page: () => SettingsScreen(),
      transition: Transition.rightToLeft,
      bindings: [NavigationBinding(), ProfileBinding()],
    ),
    GetPage(
      name: RoutesName.changePasswordScreen,
      page: () => ChangePasswordScreen(),
      transition: Transition.rightToLeft,
      bindings: [NavigationBinding(), ProfileBinding()],
    ),
    GetPage(
      name: RoutesName.termsConditionScreen,
      page: () => TermsConditionScreen(),
      transition: Transition.rightToLeft,
      binding: NavigationBinding(),
    ),
    GetPage(
      name: RoutesName.privacyPolicyScreen,
      page: () => PrivacyPolicyScreen(),
      transition: Transition.rightToLeft,
      binding: NavigationBinding(),
    ),
    GetPage(
      name: RoutesName.guidesScreen,
      page: () => GuidesScreen(),
      transition: Transition.rightToLeft,
      binding: NavigationBinding(),
    ),
    GetPage(
      name: RoutesName.aboutUsScreen,
      page: () => AboutUsScreen(),
      transition: Transition.rightToLeft,
      binding: NavigationBinding(),
    ),
  ];
}