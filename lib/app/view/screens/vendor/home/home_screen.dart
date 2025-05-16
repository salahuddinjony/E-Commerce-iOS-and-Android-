import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/core/route_path.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/owner_appbar/owner_appbar.dart'
    show OwnerAppbar;

import '../../../common_widgets/owner_nav/owner_nav.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: const OwnerNav(
        currentIndex: 0,
      ),
      body: Column(
        children: [
          OwnerAppbar(
            scaffoldKey: GlobalKey<ScaffoldState>(),
            notificationOnTap: () {
              context.pushNamed(
                RoutePath.notificationScreen,
              );
            },
          ),


        ],
      ),
    );
  }
}
