import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/global/helper/extension/extension.dart';
import 'package:local/app/view/screens/splash/splash_screen.dart';
import 'package:local/app/view/screens/vendor/add_product/add_product_screen.dart';
import 'package:local/app/view/screens/vendor/home/home_screen.dart';
import 'package:local/app/view/screens/vendor/order_request/order_request_screen.dart';
import 'package:local/app/view/screens/vendor/orders/orders_screen.dart';
import 'package:local/app/view/screens/vendor/profile/profile_screen.dart';
import 'route_path.dart';

class AppRouter {
  static final GoRouter initRoute = GoRouter(
      initialLocation: RoutePath.homeScreen.addBasePath,
      debugLogDiagnostics: true,
      navigatorKey: GlobalKey<NavigatorState>(),
      routes: [
        ///======================= Initial Route =======================
        GoRoute(
          name: RoutePath.splashScreen,
          path: RoutePath.splashScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child:  SplashScreen(),
            state: state,
          ),
        ),

        ///======================= Vendor Section =======================
        GoRoute(
          name: RoutePath.homeScreen,
          path: RoutePath.homeScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child:  const HomeScreen(),
            state: state,
          ),
        ),

        ///======================= ordersScreen =======================
        GoRoute(
          name: RoutePath.ordersScreen,
          path: RoutePath.ordersScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child:  const OrdersScreen(),
            state: state,
          ),
        ),

        ///======================= AddProductScreen =======================
        GoRoute(
          name: RoutePath.addProductScreen,
          path: RoutePath.addProductScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child:  const AddProductScreen(),
            state: state,
          ),
        ),

        ///======================= OrderRequestScreen =======================
        GoRoute(
          name: RoutePath.orderRequestScreen,
          path: RoutePath.orderRequestScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child:  const OrderRequestScreen(),
            state: state,
          ),
        ),

        ///======================= ProfileScreen =======================
        GoRoute(
          name: RoutePath.profileScreen,
          path: RoutePath.profileScreen.addBasePath,
          pageBuilder: (context, state) => _buildPageWithAnimation(
            child:  const ProfileScreen(),
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
