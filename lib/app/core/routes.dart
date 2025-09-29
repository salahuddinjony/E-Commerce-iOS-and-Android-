import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:local/app/global/helper/extension/extension.dart';
import 'package:local/app/utils/enums/transection_type.dart';
import 'package:local/app/view/common_widgets/map/screen/map_picker_screen.dart';
import 'package:local/app/view/screens/authentication/choose_auth/choose_auth_screen.dart';
import 'package:local/app/view/screens/authentication/forget_password/forget_password_screen.dart';
import 'package:local/app/view/screens/authentication/otp/otp_screen.dart';
import 'package:local/app/view/screens/authentication/reset_password/reset_password_screen.dart';
import 'package:local/app/view/screens/authentication/sign_in/sign_in_screen.dart';
import 'package:local/app/view/screens/authentication/sign_up/widgets/next.dart';
import 'package:local/app/view/screens/authentication/sign_up/sign_up_screen.dart';
import 'package:local/app/view/screens/features/client/user_home/custom_design/screen/custom_design_screen.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/product_details/category_wise_product/screen/category_wise_products.dart';
import 'package:local/app/view/screens/features/client/user_order/controller/user_order_controller.dart';
import 'package:local/app/view/screens/features/vendor/orders/models/general_order_response_model.dart';
import 'package:local/app/view/screens/splash/splash_screen.dart';
import 'package:local/app/view/screens/features/client/chat/inbox_screen/chat_screen/screen/chat_screen.dart';
import 'package:local/app/view/screens/features/client/support/order_mangement/order_manegment_screen.dart';
import 'package:local/app/view/screens/features/client/support/support_screen.dart';
import 'package:local/app/view/screens/features/client/user_home/controller/user_home_controller.dart';
import 'package:local/app/view/screens/features/client/user_home/user_home_screen.dart';
import 'package:local/app/view/screens/features/client/user_home/user_profile/category/category_screen.dart';
import 'package:local/app/view/screens/features/client/user_home/user_profile/order_history/order_history_screen.dart';
import 'package:local/app/view/screens/features/client/user_home/user_profile/user_profile_screen.dart';
import 'package:local/app/view/screens/features/client/user_order/screen/user_order_screen.dart';
import 'package:local/app/view/screens/features/vendor/home/home_screen.dart';
import 'package:local/app/view/screens/features/vendor/orders/controller/order_controller.dart';
import 'package:local/app/view/screens/features/vendor/orders/models/custom_order_response_model.dart';
import 'package:local/app/view/screens/features/vendor/orders/screen/orders_screen.dart';
import 'package:local/app/view/screens/features/vendor/products_and_category/product/screen/product_screen.dart'
    show ProductScreen;
import 'package:local/app/view/screens/features/vendor/profile/help_center/help_center_screen.dart';
import 'package:local/app/view/screens/features/vendor/profile/personal_info/edit_profile/screen/edit_profile_screen.dart';
import 'package:local/app/view/screens/features/vendor/profile/personal_info/personal_info_screen.dart';
import 'package:local/app/view/screens/features/vendor/profile/profile_screen.dart';
import 'package:local/app/view/screens/features/vendor/profile/transaction/transaction_screen.dart';
import 'package:local/app/view/screens/features/vendor/profile/wallet/wallet_screen.dart';
import '../view/screens/common_screen/about_us/about_us_screen.dart';
import '../view/screens/common_screen/change_password/change_password_screen.dart';
import '../view/screens/common_screen/faq_screen/faq_screen.dart';
import '../view/screens/common_screen/notification/notification_screen.dart';
import '../view/screens/common_screen/onboarding_screen/onboarding_screen.dart';
import '../view/screens/common_screen/privacy/privacy_policy_screen.dart';
import '../view/screens/common_screen/terms_conditions/terms_condition_screen.dart';
import '../view/screens/features/client/support/account_security/account_security_screen.dart';
import '../view/screens/features/client/support/u_tee_hub_account/u_tee_hub_account.dart';
import '../view/screens/features/client/user_home/shop_details/order_overview_page/screen/order_overview_screen.dart';
import '../view/screens/features/client/user_home/shop_details/add_address/screen/add_address_screen.dart';
import '../view/screens/features/client/user_home/shop_details/product_details/screen/product_details_screen.dart';
import '../view/screens/features/client/user_home/shop_details/screen/shop_details_screen.dart';
import '../view/screens/features/client/user_order/user_order_details/screen/user_order_details_screen.dart';
import '../view/screens/features/vendor/home/view_order/view_order_details/screen/view_order_details.dart';
import '../view/screens/features/vendor/home/view_order/view_order_screen.dart';
import '../view/screens/features/vendor/orders/order_details/screen/order_details_screen.dart';
import '../view/screens/features/vendor/products_and_category/product/add_product/screen/add_product_screen.dart';
import '../view/screens/features/vendor/profile/business_documents/business_documents_screen.dart';
import 'route_path.dart';
import 'package:local/app/view/screens/features/client/chat/inbox_screen/screen/inbox_screen.dart';

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
            // child: const HomeScreen(),
            child: const  ChooseAuthScreen(),
            state: state,
          ),
        ),

        ///======================= Auth Section =======================
        GoRoute(
          name: RoutePath.signUpScreen,
          path: RoutePath.signUpScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child:  SignUpScreen(),
            state: state,
          ),
        ),

        ///=======================  =======================
        GoRoute(
          name: RoutePath.signInScreen,
          path: RoutePath.signInScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
              child:  SignInScreen(),
              state: state,
              transitionType: TransitionType.detailsScreen),
        ),

        ///=======================  =======================
        GoRoute(
          name: RoutePath.forgetPasswordScreen,
          path: RoutePath.forgetPasswordScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child:  ForgetPasswordScreen(),
            state: state,
          ),
        ),

        ///=======================  =======================
        GoRoute(
          name: RoutePath.otpScreen,
          path: RoutePath.otpScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child:  OtpScreen(),
            state: state,
          ),
        ),

        ///=======================  =======================
        GoRoute(
          name: RoutePath.resetPasswordScreen,
          path: RoutePath.resetPasswordScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child:  ResetPasswordScreen(),
            state: state,
          ),
        ),

        ///======================= Vendor Section =======================
        GoRoute(
          name: RoutePath.homeScreen,
          path: RoutePath.homeScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
              child:  HomeScreen(), state: state, disableAnimation: true),
        ),



      ///======================= ordersScreen =======================
        GoRoute(
          name: RoutePath.ordersScreen,
          path: RoutePath.ordersScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
              child: OrdersScreen(),
              state: state,
              disableAnimation: true),
        ),

        ///======================= Category =======================
        GoRoute(
          name: RoutePath.categoryScreen,
          path: RoutePath.categoryScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
              child: const CategoryScreen(),
              state: state,
              disableAnimation: true
              
              ),
        ),

        ///======================= AddProductScreen =======================
        GoRoute(
          name: RoutePath.addProductScreen,
          path: RoutePath.addProductScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child:  AddProductScreen(),
            state: state,
          ),
        ),

        ///======================= ProfileScreen =======================
        GoRoute(
          name: RoutePath.profileScreen,
          path: RoutePath.profileScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
              child:  ProfileScreen(),
              state: state,
              disableAnimation: true),
        ),

        ///======================= PersonalInfoScreen =======================
        GoRoute(
          name: RoutePath.personalInfoScreen,
          path: RoutePath.personalInfoScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child:  PersonalInfoScreen(),
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
            child:  TransactionScreen(),
            state: state,
          ),
        ),

        ///======================= AboutUsScreen =======================
        GoRoute(
          name: RoutePath.aboutUsScreen,
          path: RoutePath.aboutUsScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
              child:  AboutUsScreen(),
              state: state,
              transitionType: TransitionType.detailsScreen),
        ),

        ///======================= PrivacyPolicyScreen =======================
        GoRoute(
          name: RoutePath.privacyPolicyScreen,
          path: RoutePath.privacyPolicyScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
              child:  PrivacyPolicyScreen(),
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
              child:  TermsConditionScreen(),
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
            child:  NotificationScreen(),
            state: state,
          ),
        ),

        ///======================= User Section =======================
        GoRoute(
          name: RoutePath.userHomeScreen,
          path: RoutePath.userHomeScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
              child: UserHomeScreen(), state: state, disableAnimation: true),
        ),

        ///======================= ChatScreen Section =======================
        GoRoute(
          name: RoutePath.chatScreen,
          path: RoutePath.chatScreen.addBasePath,
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            final conversationId = extra['conversationId'] as String? ?? '';
            final userId = extra['userId'] as String? ?? '';
            final receiverRole = extra['receiverRole'] as String? ?? '';
            final receiverName = extra['receiverName'] as String? ?? '';
            final receiverImage = extra['receiverImage'] as String? ?? '';
            final isVendor = extra['isVendor'] as bool? ?? false;

            return _buildPageWithAnimation(
              child: ChatScreen(
                userRole: extra['userRole'] as String? ?? '',
                conversationId: conversationId,
                userId: userId,
                receiverRole: receiverRole,
                receiverName: receiverName,
                isVendor: isVendor,
                receiverImage: receiverImage,
              ),
              state: state,
              transitionType: TransitionType.detailsScreen,
            );
          },
        ),

        GoRoute(
          name: RoutePath.categoryWiseProducts,
          path: RoutePath.categoryWiseProducts.addBasePath,
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            final categoryName = extra['categoryName'] as String? ?? '';
            final products = extra['products'] as List? ?? [];
            final categoryImage = extra['categoryImage'] as String? ?? '';
            final categoryId = extra['categoryId'] as String? ?? '';

            return _buildPageWithAnimation(
              child: CategoryWiseProducts(
                categoryName: categoryName,
                products: products.obs,
                categoryImage: categoryImage,
                categoryId: categoryId,
              ),
              state: state,
            );
          },
        ),

        ///======================= InboxScreen Section =======================
        GoRoute(
          name: RoutePath.inboxScreen,
          path: RoutePath.inboxScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
              child:  InboxScreen(), state: state, disableAnimation: true),
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
              child:  UserProfileScreen(),
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

        ///=======================  ShopDetailsScreen =======================
        GoRoute(
          name: RoutePath.shopDetailsScreen,
          path: RoutePath.shopDetailsScreen.addBasePath,
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            final image = extra['image'] as String? ?? '';
            final location = extra['location'] as String? ?? '';
            final name = extra['name'] as String? ?? '';
            final vendorId = extra['vendorId'] as String? ?? '';
            return _buildPageWithAnimation(
              child: ShopDetailsScreen(
                imageUrl: image,
                shopLocation: location,
                shopName: name,
                vendorId: vendorId,
              ),
              state: state,
            );
          },
        ),

        ///=======================  CustomDesignScreen =======================
        GoRoute(
          name: RoutePath.customDesignScreen,
          path: RoutePath.customDesignScreen.addBasePath,
          pageBuilder: (context, state){
            final extra = state.extra as Map<String, dynamic>? ?? {};
            final vendorId = extra['vendorId'] as String? ?? '';
            final isFromCustomHub = extra['isFromCustomHub'] as bool? ?? false;
            return _buildPageWithAnimation(
              child: CustomDesignScreen(
                vendorId: vendorId, 
                isFromCustomHub: isFromCustomHub,
              ),
              state: state,
            );
          }
           
          

          
        ),

        GoRoute(
          name: RoutePath.faqScreen,
          path: RoutePath.faqScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: FaqScreen(),
            state: state,
          ),
        ),
        GoRoute(
          name: RoutePath.orderManegmentScreen,
          path: RoutePath.orderManegmentScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const OrderManegmentScreen(),
            state: state,
          ),
        ),
        GoRoute(
          name: RoutePath.accountSecurityScreen,
          path: RoutePath.accountSecurityScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const AccountSecurityScreen(),
            state: state,
          ),
        ),
        GoRoute(
          name: RoutePath.uTeeHubAccount,
          path: RoutePath.uTeeHubAccount.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child: const UTeeHubAccount(),
            state: state,
          ),
        ),

        GoRoute(
          name: RoutePath.orderOverviewScreen,
          path: RoutePath.orderOverviewScreen.addBasePath,
          pageBuilder: (context, state){
            final extra = state.extra as Map<String, dynamic>? ?? {};
           final vendorId=extra['vendorId'] as String? ?? '';
           final productId=extra['productId'] as String? ?? '';
           final controller = extra['controller'];
           final isCustom = extra['isCustom'] as bool? ?? false;
           final productImage = extra['ProductImage'] as String? ?? '';
           final productName= extra['productName'] as String? ?? '';
           final productCategoryName= extra['productCategoryName'] as String? ?? '';

            return _buildPageWithAnimation(
              child:  OrderOverviewScreen(
                vendorId: vendorId,
                productId: productId,
                controller: controller,
                isCustom: isCustom,
                productImage: productImage,
                productName: productName,
                productCategoryName: productCategoryName,
              ),
              state: state,
            );
          },
        ),
   

        ///=======================  ViewMapScreen =======================
        // GoRoute(
        //   name: RoutePath.viewMapScreen,
        //   path: RoutePath.viewMapScreen.addBasePath,
        //   pageBuilder: (context, state) => _buildPageWithAnimation(
        //     child: ViewMapScreen(),
        //     state: state,
        //   ),
        // ),

        ///=======================  MapPickerScreen =======================
        GoRoute(
          name: RoutePath.mapPickerScreen,
          path: RoutePath.mapPickerScreen.addBasePath,
          pageBuilder: (context, state) {
            final controller = Get.find<UserHomeController>();
            final lat = double.tryParse(controller.latitude.value.toString()) ?? 0.0;
            final lng = double.tryParse(controller.longitude.value.toString()) ?? 0.0;
            return _buildPageWithAnimation(

              
              child: MapPickerScreen(
                initialPosition: LatLng(lat, lng),
              ),
              state: state,
            );
          },
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
              child: ProductScreen(), state: state, disableAnimation: true),
        ),

        ///=======================  PendingDetailsScreen =======================
        GoRoute(
          name: RoutePath.pendingDetailsScreen,
          path: RoutePath.pendingDetailsScreen.addBasePath,
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            final orderData = extra?['orderData'];
            final isCustomOrder = extra?['isCustomOrder'] ?? false;
            
            return _buildPageWithAnimation(
              child: OrderDetailsScreen(
                orderData: orderData,
                isCustomOrder: isCustomOrder,
                controller: OrdersController(),
              ),
              state: state,
            );
          },
        ),

        ///======================= VendorMessageScreen =======================
        GoRoute(
          name: RoutePath.vendorMessageScreen,
          path: RoutePath.vendorMessageScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
              child: InboxScreen(isVendor: true),
              state: state,
              disableAnimation: true),
        ),

        ///=======================  PendingDetailsScreen =======================
        GoRoute(
          name: RoutePath.viewOrderScreen,
          path: RoutePath.viewOrderScreen.addBasePath,
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?; 
            final status = extra?['status'] as String? ?? '';
            final orderData = (extra?['orderData'] as List<Order>?) ?? const <Order>[];
            return _buildPageWithAnimation(
              child: ViewOrderScreen(
                status: status,
                orderData: orderData,
              ),
              state: state,
            );
          },
        ),

        ///=======================  ViewOrderDetails =======================
        GoRoute(
          name: RoutePath.viewOrderDetails,
          path: RoutePath.viewOrderDetails.addBasePath,
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            final order = extra?['order'] as Order?;
            if (order == null) {
              return _buildPageWithAnimation(
                child: const SizedBox.shrink(),
                state: state,
                disableAnimation: true,
              );
            }

            return _buildPageWithAnimation(
              child: ViewOrderDetails(order: order),
              state: state,
            );
          },
        ),

        ///=======================  ViewOrderDetails =======================
        GoRoute(
          name: RoutePath.productDetailsScreen,
          path: RoutePath.productDetailsScreen.addBasePath,
          pageBuilder: (context, state){
              final extra = state.extra as Map<String, dynamic>? ?? {};
            final product = extra['product'];
            final vendorId = extra['vendorId'] as String? ?? '';
            final productCategoryName = extra['productCategoryName'] as String? ?? '';
            return _buildPageWithAnimation(
              child: ProductDetailsScreen(
                product: product,
                vendorId: vendorId,
                productCategoryName: productCategoryName,
              ),
              state: state,
            );


          },
        ),    ///=======================  userOrderDetailsScreen =======================
        GoRoute(
          name: RoutePath.userOrderDetailsScreen,
          path: RoutePath.userOrderDetailsScreen.addBasePath,
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            final isCustom = extra['isCustom'] as bool;
            final orderData = isCustom
                ? extra['orderData'] as Order?
                : extra['orderData'] as GeneralOrder?;
            final controller = extra['controller'] as UserOrderController;
            return _buildPageWithAnimation(
              child: UserOrderDetailsScreen(
                isCustom: isCustom,
                orderData: orderData,
                controller: controller,
                
              ),
              state: state,
            );
          }
        ),
        ///=======================  ViewOrderDetails =======================
        GoRoute(
          name: RoutePath.addAddressScreen,
          path: RoutePath.addAddressScreen.addBasePath,
          pageBuilder: (context, state){
            final extra = state.extra as Map<String, dynamic>? ?? {};
            final vendorId = extra['vendorId'] as String? ?? '';
            final productId = extra['productId'] as String? ?? '';
            final controller = extra['controller'];
            final isCustomOrder = extra['isCustomOrder'] as bool? ?? false;
            final productImage = extra['ProductImage'] as String? ?? '';
            final productName = extra['productName'] as String? ?? '';
            final productCategoryName = extra['productCategoryName'] as String? ?? '';
            return _buildPageWithAnimation(
              child: AddAddressScreen(
                vendorId: vendorId,
                productId: productId,
                controller: controller,
                isCustomOrder: isCustomOrder,
                productImage: productImage,
                productName: productName,
                productCategoryName: productCategoryName,
              ),
              state: state,
            );
          },
        ),

        ///=======================  UserOrderScreen =======================
        GoRoute(
          name: RoutePath.userOrderScreen,
          path: RoutePath.userOrderScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
              child: UserOrderScreen(), state: state, disableAnimation: true),
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
