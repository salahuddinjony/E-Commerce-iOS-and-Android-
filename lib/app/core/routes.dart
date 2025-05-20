import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/global/helper/extension/extension.dart';
import 'package:local/app/utils/enums/transection_type.dart';
import 'package:local/app/view/screens/authentication/choose_auth/choose_auth_screen.dart';
import 'package:local/app/view/screens/authentication/forget_password/forget_password_screen.dart';
import 'package:local/app/view/screens/authentication/otp/otp_screen.dart';
import 'package:local/app/view/screens/authentication/reset_password/reset_password_screen.dart';
import 'package:local/app/view/screens/authentication/sign_in/sign_in_screen.dart';
import 'package:local/app/view/screens/authentication/sign_up/next.dart';
import 'package:local/app/view/screens/authentication/sign_up/sign_up_screen.dart';
import 'package:local/app/view/screens/notification/notification_screen.dart';
import 'package:local/app/view/screens/onboarding_screen/onboarding_screen.dart';
import 'package:local/app/view/screens/splash/splash_screen.dart';
import 'package:local/app/view/screens/user/chat/chat_screen.dart';
import 'package:local/app/view/screens/user/chat/inbox/inbox_screen.dart';
import 'package:local/app/view/screens/user/support/support_screen.dart';
import 'package:local/app/view/screens/user/user_home/user_home_screen.dart';
import 'package:local/app/view/screens/user/user_home/user_profile/order_history/order_history_screen.dart';
import 'package:local/app/view/screens/user/user_home/user_profile/user_profile_screen.dart';
import 'package:local/app/view/screens/user/user_home/view_map/view_map_screen.dart';
import 'package:local/app/view/screens/user/user_order/user_order_screen.dart';
import 'package:local/app/view/screens/vendor/home/home_screen.dart';
import 'package:local/app/view/screens/vendor/order_request/order_request_screen.dart';
import 'package:local/app/view/screens/vendor/order_request/order_view/order_view_screen.dart';
import 'package:local/app/view/screens/vendor/orders/orders_screen.dart';
import 'package:local/app/view/screens/vendor/product/product_screen.dart' show ProductScreen;
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
import '../view/screens/vendor/product/add_product/add_product_screen.dart';
import '../view/screens/vendor/profile/business_documents/business_documents_screen.dart';
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
            child: const SignInScreen(),
            state: state,
            transitionType: TransitionType.detailsScreen
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
              ),
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
              transitionType: TransitionType.detailsScreen),
        ),

        ///======================= PrivacyPolicyScreen =======================
        GoRoute(
          name: RoutePath.privacyPolicyScreen,
          path: RoutePath.privacyPolicyScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const PrivacyPolicyScreen(),
              state: state,
              transitionType: TransitionType.detailsScreen),
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


        ///======================= BusinessDocumentsScreen =======================
        GoRoute(
          name: RoutePath.businessDocumentsScreen,
          path: RoutePath.businessDocumentsScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const BusinessDocumentsScreen(),
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
              transitionType: TransitionType.detailsScreen),
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

        ///======================= User Section =======================
        GoRoute(
          name: RoutePath.userHomeScreen,
          path: RoutePath.userHomeScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const UserHomeScreen(),
              state: state,
              disableAnimation: true),
        ),

        ///======================= ChatScreen Section =======================
        GoRoute(
          name: RoutePath.chatScreen,
          path: RoutePath.chatScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const ChatScreen(),
              state: state,
              transitionType: TransitionType.detailsScreen),
        ),

        ///======================= InboxScreen Section =======================
        GoRoute(
          name: RoutePath.inboxScreen,
          path: RoutePath.inboxScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const InboxScreen(), state: state, disableAnimation: true),
        ),

        ///======================= SupportScreen Section =======================
        GoRoute(
          name: RoutePath.supportScreen,
          path: RoutePath.supportScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const SupportScreen(),
              state: state,
              disableAnimation: true),
        ),

        ///=======================  Section =======================
        GoRoute(
          name: RoutePath.userProfileScreen,
          path: RoutePath.userProfileScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const UserProfileScreen(),
              state: state,
              transitionType: TransitionType.detailsScreen),
        ),

        ///=======================  OrderHistoryScreen =======================
        GoRoute(
          name: RoutePath.orderHistoryScreen,
          path: RoutePath.orderHistoryScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const OrderHistoryScreen(),
            state: state,
          ),
        ),

        ///=======================  ViewMapScreen =======================
        GoRoute(
          name: RoutePath.viewMapScreen,
          path: RoutePath.viewMapScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const ViewMapScreen(),
            state: state,
          ),
        ),

        ///=======================  ViewMapScreen =======================
        GoRoute(
          name: RoutePath.nextScreen,
          path: RoutePath.nextScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const NextScreen(),
            state: state,
          ),
        ),

        ///=======================  productScreen =======================
        GoRoute(
          name: RoutePath.productScreen,
          path: RoutePath.productScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const ProductScreen(),
            state: state,
            disableAnimation: true
          ),
        ),

        ///=======================  UserOrderScreen =======================
        GoRoute(
          name: RoutePath.userOrderScreen,
          path: RoutePath.userOrderScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const UserOrderScreen(),
              state: state,
              disableAnimation: true),
        ),
      ]);

  static CustomTransitionPage _buildPageWithAnimation({
    required Widget child,
    required GoRouterState state,
    bool disableAnimation = false,
    TransitionType transitionType = TransitionType.defaultTransition,
  }) {
    if (disableAnimation) {
      return CustomTransitionPage(
        key: state.pageKey,
        child: child,
        transitionDuration: Duration.zero, // Disable animation
        transitionsBuilder: (_, __, ___, child) => child, // No transition
      );
    }

    // Custom transition for Details Screen (center open animation)
    if (transitionType == TransitionType.detailsScreen) {
      return CustomTransitionPage(
        key: state.pageKey,
        child: child,
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Center Open Animation
          var curve = Curves.easeOut; // Smooth opening
          var tween = Tween(begin: 0.0, end: 1.0); // Scale transition
          var scaleAnimation =
              animation.drive(tween.chain(CurveTween(curve: curve)));

          return ScaleTransition(
            scale: scaleAnimation,
            child: child,
          );
        },
      );
    }

    // Default Slide Transition (right to left)
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Slide from right
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

  static GoRouter get route => initRoute;
}
