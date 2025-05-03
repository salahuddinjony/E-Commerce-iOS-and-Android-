import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/global/helper/extension/extension.dart';
import 'package:local/app/view/screens/authentication/choose_auth/choose_auth_screen.dart';
import 'package:local/app/view/screens/authentication/forget_password/forget_password_screen.dart';
import 'package:local/app/view/screens/authentication/otp/otp_screen.dart';
import 'package:local/app/view/screens/authentication/reset_password/reset_password_screen.dart';
import 'package:local/app/view/screens/authentication/sign_in/sign_in_screen.dart';
import 'package:local/app/view/screens/authentication/sign_up/sign_up_screen.dart';
import 'package:local/app/view/screens/notification/notification_screen.dart';
import 'package:local/app/view/screens/onboarding_screen/onboarding_screen.dart';
import 'package:local/app/view/screens/splash/splash_screen.dart';
import 'package:local/app/view/screens/vendor/add_product/add_product_screen.dart';
import 'package:local/app/view/screens/vendor/home/home_screen.dart';
import 'package:local/app/view/screens/vendor/order_request/order_request_screen.dart';
import 'package:local/app/view/screens/vendor/order_request/order_view/order_view_screen.dart';
import 'package:local/app/view/screens/vendor/orders/orders_screen.dart';
import 'package:local/app/view/screens/vendor/profile/about_us/about_us_screen.dart';
import 'package:local/app/view/screens/vendor/profile/change_password/change_password_screen.dart';
import 'package:local/app/view/screens/vendor/profile/help_center/help_center_screen.dart';
import 'package:local/app/view/screens/vendor/profile/personal_info/edit_profile/edit_profile_screen.dart';
import 'package:local/app/view/screens/vendor/profile/personal_info/personal_info_screen.dart';
import 'package:local/app/view/screens/vendor/profile/privacy/privacy_policy_screen.dart';
import 'package:local/app/view/screens/vendor/profile/profile_screen.dart';
import 'package:local/app/view/screens/vendor/profile/terms_conditions/terms_condition_screen.dart';
import 'package:local/app/view/screens/vendor/profile/transaction/transaction_screen.dart';
import 'package:local/app/view/screens/vendor/profile/wallet/wallet_screen.dart';
import 'route_path.dart';

class AppRouter {
  static final GoRouter initRoute = GoRouter(
      initialLocation: RoutePath.splashScreen.addBasePath,
      debugLogDiagnostics: true,
      navigatorKey: GlobalKey<NavigatorState>(),
      routes: [
        ///======================= Initial Route =======================
        GoRoute(
          name: RoutePath.splashScreen,
          path: RoutePath.splashScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: SplashScreen(),
            state: state,
          ),
        ),

        ///======================= OnboardingScreen =======================
        GoRoute(
          name: RoutePath.onboardingScreen,
          path: RoutePath.onboardingScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: OnboardingScreen(),
            state: state,
          ),
        ),

        ///======================= ChooseAuthScreen =======================
        GoRoute(
          name: RoutePath.chooseAuthScreen,
          path: RoutePath.chooseAuthScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const ChooseAuthScreen(),
            state: state,
          ),
        ),

        ///======================= Auth Section =======================
        GoRoute(
          name: RoutePath.signUpScreen,
          path: RoutePath.signUpScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const SignUpScreen(),
            state: state,
          ),
        ),

        ///=======================  =======================
        GoRoute(
          name: RoutePath.signInScreen,
          path: RoutePath.signInScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: SignInScreen(),
            state: state,
          ),
        ),

        ///=======================  =======================
        GoRoute(
          name: RoutePath.forgetPasswordScreen,
          path: RoutePath.forgetPasswordScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const ForgetPasswordScreen(),
            state: state,
          ),
        ),

        ///=======================  =======================
        GoRoute(
          name: RoutePath.otpScreen,
          path: RoutePath.otpScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const OtpScreen(),
            state: state,
          ),
        ),

        ///=======================  =======================
        GoRoute(
          name: RoutePath.resetPasswordScreen,
          path: RoutePath.resetPasswordScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const ResetPasswordScreen(),
            state: state,
          ),
        ),

        ///======================= Vendor Section =======================
        GoRoute(
          name: RoutePath.homeScreen,
          path: RoutePath.homeScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const HomeScreen(), state: state, disableAnimation: true),
        ),

        ///======================= ordersScreen =======================
        GoRoute(
          name: RoutePath.ordersScreen,
          path: RoutePath.ordersScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const OrdersScreen(),
              state: state,
              disableAnimation: true),
        ),

        ///======================= AddProductScreen =======================
        GoRoute(
          name: RoutePath.addProductScreen,
          path: RoutePath.addProductScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const AddProductScreen(),
              state: state,
              disableAnimation: true),
        ),

        ///======================= OrderRequestScreen =======================
        GoRoute(
          name: RoutePath.orderRequestScreen,
          path: RoutePath.orderRequestScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const OrderRequestScreen(),
              state: state,
              disableAnimation: true),
        ),

        ///======================= ProfileScreen =======================
        GoRoute(
          name: RoutePath.profileScreen,
          path: RoutePath.profileScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const ProfileScreen(),
              state: state,
              disableAnimation: true),
        ),

        ///======================= PersonalInfoScreen =======================
        GoRoute(
          name: RoutePath.personalInfoScreen,
          path: RoutePath.personalInfoScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const PersonalInfoScreen(),
            state: state,
          ),
        ),

        ///======================= PersonalInfoScreen =======================
        GoRoute(
          name: RoutePath.walletScreen,
          path: RoutePath.walletScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const WalletScreen(),
            state: state,
          ),
        ),

        ///======================= EditProfileScreen =======================
        GoRoute(
          name: RoutePath.editProfileScreen,
          path: RoutePath.editProfileScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const EditProfileScreen(),
            state: state,
          ),
        ),

        ///======================= TransactionScreen =======================
        GoRoute(
          name: RoutePath.transactionScreen,
          path: RoutePath.transactionScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const TransactionScreen(),
            state: state,
          ),
        ),

        ///======================= AboutUsScreen =======================
        GoRoute(
          name: RoutePath.aboutUsScreen,
          path: RoutePath.aboutUsScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const AboutUsScreen(),
            state: state,
          ),
        ),

        ///======================= PrivacyPolicyScreen =======================
        GoRoute(
          name: RoutePath.privacyPolicyScreen,
          path: RoutePath.privacyPolicyScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const PrivacyPolicyScreen(),
            state: state,
          ),
        ),

        ///======================= HelpCenterScreen =======================
        GoRoute(
          name: RoutePath.helpCenterScreen,
          path: RoutePath.helpCenterScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const HelpCenterScreen(),
            state: state,
          ),
        ),

        ///======================= TermsConditionScreen =======================
        GoRoute(
          name: RoutePath.termsConditionScreen,
          path: RoutePath.termsConditionScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const TermsConditionScreen(),
            state: state,
          ),
        ),

        ///======================= ChangePasswordScreen =======================
        GoRoute(
          name: RoutePath.changePasswordScreen,
          path: RoutePath.changePasswordScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const ChangePasswordScreen(),
            state: state,
          ),
        ),

        ///======================= NotificationScreen =======================
        GoRoute(
          name: RoutePath.notificationScreen,
          path: RoutePath.notificationScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const NotificationScreen(),
            state: state,
          ),
        ),

        ///======================= OrderViewScreen =======================
        GoRoute(
          name: RoutePath.orderViewScreen,
          path: RoutePath.orderViewScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const OrderViewScreen(),
            state: state,
          ),
        ),
      ]);

  static CustomTransitionPage _buildPageWithAnimation(
      {required Widget child,
      required GoRouterState state,
      bool disableAnimation = false}) {
    if (disableAnimation) {
      return CustomTransitionPage(
        key: state.pageKey,
        child: child,
        transitionDuration: Duration.zero, // Disable animation
        transitionsBuilder: (_, __, ___, child) => child, // No transition
      );
    } else {
      return CustomTransitionPage(
        key: state.pageKey,
        child: child,
        transitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          var tween = Tween(begin: begin, end: end);
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      );
    }
  }

  static GoRouter get route => initRoute;
}
