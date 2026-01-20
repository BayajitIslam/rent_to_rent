class ApiEndpoints {
  static const String baseUrl = "http://10.10.7.76:14050";

  //====================== Auth Endpoints ======================
  static const String register = "$baseUrl/api/v1/auth/register/";
  static const String registerActivate =
      "$baseUrl/api/v1/auth/register/activate/";
  static const String forgotPasswordVerify =
      "$baseUrl/api/v1/auth/forgot-password/verify/";
  static const String login = "$baseUrl/api/v1/auth/login/";
}
