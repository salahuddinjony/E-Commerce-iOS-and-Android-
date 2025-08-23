class ApiUrl {
  // static const baseUrl = "http://10.10.20.19:5007/v1";
  static const baseUrl = "https://gmosley-uteehub-backend.onrender.com/v1/";
  // static const networkUrl = "http://10.10.20.19:5007/v1/";
  static const networkUrl = "https://gmosley-uteehub-backend.onrender.com/v1/";

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
    return "$baseUrl/user/retrieve/$userId";
  }

  static String updateProfile({required String userId}) {
    return "$baseUrl/user/update/$userId";
  }

//================Info=================
  static const privacyPolicy = "$baseUrl/privacy-policy/retrive";
  static const termsAndCondition = "$baseUrl/terms-condition/retrive";
  static const aboutUs = "$baseUrl/about-us/retrive";
  static const faq = "$baseUrl/faq/retrieve";
  static String notification({required String userId}) {
    return "/notification/retrive/consumer/$userId";
  }

  // New notification URLs
  static String getNotifications({required String consumerId}) {
    return "$baseUrl/notification/retrive/consumer/$consumerId";
    
  }

  static String dismissNotification({required String notificationId}) {
    return "$baseUrl/notification/dismiss/$notificationId";
  }

  static String clearAllNotifications({required String consumerId}) {
    return "$baseUrl/notification/clear/consumer/$consumerId";
  }



//=================Vendor=================

static String getWallet({required String id}){
  return "$baseUrl/wallet/retrieve/user/$id";
}

static String withdrawWallet= "$baseUrl/wallet/withdraw";


  //=================Order=================


         //=========Custom Order========//

  static const customOrder="$baseUrl/order/retrieve/all";
  
  static String updateCustomOrderStatus({required String orderId}) {
    return "$baseUrl}order/update/$orderId";
  }

         //=========Generel Order========//

  static const generalOrder="$baseUrl/general-order/retrieve";
  static String deleteGeneralOrder({required String orderId}) {
    return "$baseUrl/general-order/delete/$orderId";
  }
  


  





  //=================Product=================

  
  static const productList = "$baseUrl/product/retrieve";

  static String createProduct = "$baseUrl/product/create";
  
  static String productDelete({required String productId}) {
    return "$baseUrl/product/delete/$productId";
  }
  static String updateProduct({required String productId}) {
    return "$baseUrl/product/update/$productId";
  }
   //=================Category==========

  static const categoryList = "$baseUrl/category/retrieve";

  static String createCategory="$baseUrl/category/create";

  static String categoryDelete({required String categoryId}) {
    return "$baseUrl/category/delete/$categoryId";
  
  }
  static String updateCategory({required String categoryId}) {
    return "$baseUrl/category/update/$categoryId";
  }







}

