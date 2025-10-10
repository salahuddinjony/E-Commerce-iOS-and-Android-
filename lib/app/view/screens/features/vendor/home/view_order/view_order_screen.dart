import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/core/route_path.dart';
import 'package:local/app/global/helper/extension/extension.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/screens/features/vendor/home/view_order/view_order_details/controller/view_order_details_controller.dart';
import 'package:local/app/view/screens/features/vendor/orders/constants/order_constants.dart';
import 'package:local/app/view/screens/features/vendor/orders/controller/order_controller.dart';
import 'package:local/app/view/screens/features/vendor/orders/models/custom_order_response_model.dart';

import '../../../../../common_widgets/order_card/order_card.dart';

class ViewOrderScreen extends StatelessWidget {
  final String status;
  final OrdersController orderController;
   ViewOrderScreen(
      {super.key, required this.status, required this.orderController});

 

  List<Order> get filteredOrders {
    switch (status) {
      case 'pendingOrder':
        return orderController.customOrders
            .where((o) =>
                o.status.toLowerCase() == 'pending' ||
                o.status.toLowerCase() == 'offered')
            .toList();
      case 'inProgressOrder':
        return orderController.customOrders
            .where((o) => o.status.toLowerCase() == 'in-progress')
            .toList();
      default:
        return orderController.customOrders;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensure pagination works by setting isCustomOrder to true
    // since this screen displays custom orders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      orderController.isCustomOrder.value = true;
    });
    
    final list = filteredOrders;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        appBarContent: "Total Orders(${orderController.totalCustomOrder})",
        iconData: Icons.arrow_back,
      ),
      body: list.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 56.r,
                    color: AppColors.darkNaturalGray,
                  ),
                  12.verticalSpace,
                  Text(
                    'No orders found for $status',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.darkNaturalGray,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : Obx(() => ListView.builder(
              controller: orderController.scrollController,
              padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 10.w),
              itemCount: list.length + (orderController.hasMoreData.value || orderController.isPaginating.value ? 1 : 0),
              itemBuilder: (context, index) {
                // Check if this is the loading indicator item
                if (index >= list.length) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Center(
                      child: SizedBox(
                        width: 32.w,
                        height: 32.h,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.brightCyan),
                          strokeWidth: 3.0,
                        ),
                      ),
                    ),
                  );
                }

                final o = list[index];
                return OrderCard(
                  parcelId: '#${o.id}',
                  date: o.createdAt.toIso8601String().getDateTime(),
                  addressLine1: o.shippingAddress,
                  deliveryType: o.status.capitalizeFirstWord(),
                  amount: o.price.toDouble(),
                  timeAgo: '',
                  color: Color(OrderConstants.getStatusColor(o.status)),
                  imageUrl: AppConstants.demoImage,
                  onTap: () async {
                    final tag = 'order_${o.id}';
                    final controller = Get.isRegistered<ViewOrderDetailsController>(tag: tag)
                        ? Get.find<ViewOrderDetailsController>(tag: tag)
                        : Get.put(ViewOrderDetailsController(o), tag: tag);
                    await controller.refreshOrder(o.id);
                    context.pushNamed(RoutePath.viewOrderDetails, extra: {'order': o});
                  },
                );
              },
            )),
    );
  }
}
