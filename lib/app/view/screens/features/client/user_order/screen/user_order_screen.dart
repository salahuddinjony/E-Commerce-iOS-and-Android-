import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/client_nav_bar/nav_bar.dart';
import 'package:local/app/view/screens/features/client/user_order/widgets/tab_bar_view_content.dart';
import '../controller/user_order_controller.dart';

class UserOrderScreen extends StatelessWidget {
  UserOrderScreen({super.key});

  final UserOrderController controller = Get.find<UserOrderController>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: const CustomAppBar(
          appBarContent: "Order",
        ),
        bottomNavigationBar: CustomNavBar(currentIndex: 1),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabBar(
                indicatorColor: AppColors.brightCyan,
                labelColor: AppColors.brightCyan,
                unselectedLabelColor: Colors.grey,
                labelStyle:
                    TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp),
                tabs: const [
                  Tab(text: 'Orders'),
                  Tab(text: 'Date Extn Req'),
                ],
              ),
              SizedBox(height: 12.h),
              Expanded(
                child: TabBarView(
                  children: [

                    // My Orders
                    RefreshIndicator(
                      backgroundColor: Colors.white,
                      color: AppColors.brightCyan,
                      child: buildMyOrdersList(context, controller),
                      onRefresh: controller.fetchAllOrders,
                    ),

                    // Date Extension Requests
                    RefreshIndicator(
                      backgroundColor: Colors.white,
                      color: AppColors.brightCyan,
                       onRefresh: controller.fetchAllOrders,
                      child: buildExtendRequestsList(context, controller),
                     
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
