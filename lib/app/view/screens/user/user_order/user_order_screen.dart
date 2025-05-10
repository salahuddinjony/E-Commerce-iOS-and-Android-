import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/core/route_path.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:local/app/view/common_widgets/nav_bar/nav_bar.dart';
import 'package:local/app/view/common_widgets/order_item/order_item.dart';

class UserOrderScreen extends StatelessWidget {
  const UserOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: const CustomNavBar(currentIndex: 1),
      appBar: const CustomAppBar(
        appBarContent: "Order",
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 20.h),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns in the grid
            crossAxisSpacing: 10.w, // Spacing between columns
            mainAxisSpacing: 10.h, // Spacing between rows
            childAspectRatio: 0.7, // Ratio of height to width of each grid item
          ),
          itemCount: 10, // Assuming 10 items for now, adjust as per actual data
          itemBuilder: (context, index) {
            return OrderItem(
              imageUrl: AppConstants.teeShirt,
              productName: "Short Sleeve Tee",
              productMaterial: "100% Cotton",
              productPrice: "\$22.23", onTap: () {
              context.pushNamed(RoutePath.orderViewScreen,);

            },
            );
          },
        ),
      ),
    );
  }
}


