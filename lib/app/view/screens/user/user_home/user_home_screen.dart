import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/core/route_path.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/common_home_app_bar/common_home_app_bar.dart';
import 'package:local/app/view/common_widgets/nav_bar/nav_bar.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: const CustomNavBar(currentIndex: 0),
      body: Column(
        children: [
          CommonHomeAppBar(
            onTap: () {},
            scaffoldKey: GlobalKey<ScaffoldState>(),
            aboutUsOnTap: () {
              context.pushNamed(RoutePath.aboutUsScreen,);

            },
            privacyTap: () {
              context.pushNamed(RoutePath.privacyPolicyScreen,);

            },
            termsTap: () {
              context.pushNamed(RoutePath.termsConditionScreen,);

            },
          )
        ],
      ),
    );
  }
}
