class ApiUrl {
  static const baseUrl = "http://10.10.10.74:5007/v1";

  ///================================= User Authentication url==========================
  static const login = "/user/auth/login";
  static const forgetPassword = "/user/auth/forget-password/send-otp";
  static const register = "/user/create";
  static const emailVerify = "/user/auth/verify-email";
  static const forgetOtp = "/user/auth/verify-otp";
  static const resendCode = "/user/auth/email-verification/resend-code";
  static const resetPassword = "/user/auth/reset-password";
  static const changePassword = "/user/auth/change-password";

  //=================Profile=================
  static String getProfile({required String userId}) {
    return "/user/retrieve/$userId";
  }

  static String updateProfile({required String userId}) {
    return "/user/update/$userId";
  }

//================Info=================
  static const privacyPolicy = "/privacy-policy/retrive";
  static const termsAndCondition = "/terms-condition/retrive";
  static const aboutUs = "/about-us/retrive";
  static const faq = "/faq/retrieve";
  static String notification({required String userId}) {
    return "/notification/retrive/consumer/$userId";
  }












}
