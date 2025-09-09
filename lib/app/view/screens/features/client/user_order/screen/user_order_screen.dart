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
              IconButton(onPressed:(){
                controller.fetchCustomOrders();
              }, icon: Icon(Icons.arrow_back)),
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
        itemCount: controller.customOrders.length,
        separatorBuilder: (_, __) => SizedBox(height: 16.h),
        itemBuilder: (context, index) {
          final item = controller.customOrders[index];
          return GestureDetector(
            onTap: () {
              context.pushNamed(
                RoutePath.userOrderDetailsScreen,
              );
            },
            child: OrderItemCard(
              imagePath: item.id!,
              title: item.status,
              subtitle: item.client!,
              description: item.orderId!,
              isActive:false,
            ),
          );
        },
      );
    });
  }

  Widget buildExtendRequestsList(BuildContext context) {
    return Obx(() {
      return ListView.separated(
        itemCount: controller.customOrders.length,
        separatorBuilder: (_, __) => SizedBox(height: 16.h),
        itemBuilder: (context, index) {
          final item = controller.customOrders[index];
          return ExtendRequestCard(
            imagePath: item.client!,
            title: item.client!,
            subtitle: item.createdAt.toString()!,
            description: item.summery!,
            requestedDays: item.quantity ?? 0,
            isAccepted: false,
            onAccept: item.isBlank == false
                ? () {
                    controller.customOrders[index] == true;
                    showCustomSnackBar(
                      'You accepted a -day extension for "".',
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
