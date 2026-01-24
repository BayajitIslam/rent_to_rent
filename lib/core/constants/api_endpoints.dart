class ApiEndpoints {
  static const String baseUrl = "https://rentoapi.dsrt321.online";

  //====================== Auth Endpoints ======================
  static const String register = "$baseUrl/api/v1/auth/register/";
  static const String registerActivate =
      "$baseUrl/api/v1/auth/register/activate/";
  static const String forgotPasswordVerify =
      "$baseUrl/api/v1/auth/forgot-password/verify/";
  static const String login = "$baseUrl/api/v1/auth/login/";
  static const String forgetPasswordSendOtp =
      "$baseUrl/api/v1/auth/forgot-password/";
  static const String resetPassword =
      "$baseUrl/api/v1/auth/forgot-password/set/password/";

  //====================== services Endpoints ======================
  static const String emailReplyDraft =
      "$baseUrl/api/v1/service/email-reply-draft/";
  static const String generateContract =
      "$baseUrl/api/v1/service/contact-creation/";
  static const String contractcheck =
      "$baseUrl/api/v1/service/contract-analysis/";
  static const String locationSuitability =
      "$baseUrl/api/v1/service/location-suitability/";

  //====================== Profile Endpoints ======================
  static const String profile = "$baseUrl/api/v1/user/profile/details/";
  static const String updateProfile = "$baseUrl/api/v1/user/profile/update/";
  static const String feedback = "$baseUrl/api/v1/user/feedback/";
  static const String changePassword =
      "$baseUrl/api/v1/user/profile/change-password/";
  static const String deleteAccount = "$baseUrl/api/v1/user/profile/delete/";
  static const String savedFiles =
      "$baseUrl/api/v1/service/contact-creation/files/";

  //====================== Subscription Endpoints ======================
  static const String subscription = "$baseUrl/api/v1/payment/plans/";
  static const String createPaymentIntent =
      "$baseUrl/api/v1/payment/subscriptions/create/";
}
