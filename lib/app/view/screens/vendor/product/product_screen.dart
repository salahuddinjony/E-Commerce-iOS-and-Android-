import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/common_widgets/owner_nav/owner_nav.dart';

import '../../../../core/route_path.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../common_widgets/custom_appbar/custom_appbar.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: OwnerNav(currentIndex: 2),
      appBar: CustomAppBar(
        appBarContent: "Products",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            CustomButton(
              title: "Add Product",
              onTap: () {
                context.pushNamed(RoutePath.addProductScreen,);

              },
              textColor: AppColors.white,
              fillColor: AppColors.brightCyan,
            )
          ],
        ),
      ),
    );
  }
}
