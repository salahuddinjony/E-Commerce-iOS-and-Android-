import 'package:flutter/material.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/owner_nav/owner_nav.dart';

class OrderRequestScreen extends StatelessWidget {
  const OrderRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: OwnerNav(currentIndex: 3),
     appBar: CustomAppBar(appBarContent: "Order Request",),
    );
  }
}
