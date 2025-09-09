import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/client_nav_bar/nav_bar.dart';
import 'package:local/app/view/screens/features/client/user_order/widgets/extend_request_card.dart';
import 'package:local/app/view/screens/features/client/user_order/widgets/order_item_card.dart';

import '../../../../../../core/route_path.dart';
import '../controller/user_order_controller.dart';
import '../../../../../../global/helper/toast_message/toast_message.dart';

class UserOrderScreen extends StatelessWidget {
  UserOrderScreen({super.key});

  final UserOrderController controller = Get.put(UserOrderController());

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
                    buildMyOrdersList(context),
                    buildExtendRequestsList(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMyOrdersList(BuildContext context) {
    return Obx(() {
      return ListView.separated(
        itemCount: controller.myOrders.length,
        separatorBuilder: (_, __) => SizedBox(height: 16.h),
        itemBuilder: (context, index) {
          final item = controller.myOrders[index];
          return GestureDetector(
            onTap: () {
              context.pushNamed(
                RoutePath.userOrderDetailsScreen,
              );
            },
            child: OrderItemCard(
              imagePath: item['image']!,
              title: item['title']!,
              subtitle: item['subtitle']!,
              description: item['description']!,
              isActive: item['isActive'] ?? false,
            ),
          );
        },
      );
    });
  }

  Widget buildExtendRequestsList(BuildContext context) {
    return Obx(() {
      return ListView.separated(
        itemCount: controller.extendDateRequests.length,
        separatorBuilder: (_, __) => SizedBox(height: 16.h),
        itemBuilder: (context, index) {
          final item = controller.extendDateRequests[index];
          return ExtendRequestCard(
            imagePath: item['image']!,
            title: item['title']!,
            subtitle: item['subtitle']!,
            description: item['description']!,
            requestedDays: item['requestedDays'] ?? 0,
            isAccepted: item['isAccepted'] ?? false,
            onAccept: item['isAccepted'] == false
                ? () {
                    controller.acceptRequest(index);
                    showCustomSnackBar(
                      'You accepted a ${item['requestedDays']}-day extension for "${item['title']}".',
                      isError: false,
                      getXSnackBar: true,
                    );
                  }
                : null,
          );
        },
      );
    });
  }
}
