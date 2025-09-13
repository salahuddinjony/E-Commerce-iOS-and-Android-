import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/core/route_path.dart';
import 'package:local/app/global/helper/extension/extension.dart';
import 'package:local/app/global/helper/toast_message/toast_message.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/widgets/not_found.dart';
import 'package:local/app/view/screens/features/client/user_order/controller/user_order_controller.dart';
import 'package:local/app/view/screens/features/client/user_order/screen/extend_history_screen.dart';
import 'package:local/app/view/screens/features/client/user_order/widgets/extend_request_card.dart';
import 'package:local/app/view/screens/features/client/user_order/widgets/order_item_card.dart';
import 'package:local/app/view/screens/features/client/user_order/widgets/ractangle_card_shimmer.dart';

Widget buildMyOrdersList(BuildContext context, UserOrderController controller) {
  return Obx(() {
    if (controller.isLoading.value) {
      return const RectangleCardShimmer();
    }
    final generalOrders = controller.generalOrders;
    final customOrders = controller.customOrders;
    if (generalOrders.isEmpty && customOrders.isEmpty) {
      return LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: NotFound(
              icon: Icons.production_quantity_limits_outlined,
              message: 'You have no orders at the moment.',
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: generalOrders.length + customOrders.length,
      separatorBuilder: (_, __) => SizedBox(height: 8.h),
      itemBuilder: (context, index) {
        // Show general orders first, then custom orders
        if (index < generalOrders.length) {
          final item = generalOrders[index];
          final imagePath = AppConstants.demoImage;
          final title = item.id;
          final subtitle = item.createdAt.formatDate();
          final description = item.shippingAddress;
          final isActive = true;

          return GestureDetector(
            onTap: () {
              context.pushNamed(
                RoutePath.userOrderDetailsScreen,
                extra:{
                  'isCustom': false,
                  'orderData': item,
                }
              );
            },
            child: OrderItemCard(
              imagePath: imagePath,
              title: title,
              subtitle: subtitle,
              description: description,
              isActive: isActive,
            ),
          );
        } else {
          final customIndex = index - generalOrders.length;
          final item = customOrders[customIndex];
          final imagePath = (item.designFiles.isNotEmpty)
              ? item.designFiles.first
              : AppConstants.demoImage;
          final title = item.orderId;
          final subtitle = item.deliveryDate != null
              ? item.deliveryDate!.formatDate()
              : 'No date';
          final description = item.summery;
          final isActive = true;

          return GestureDetector(
            onTap: () {
              context.pushNamed(
                RoutePath.userOrderDetailsScreen,
                extra:{
                  'isCustom': true,
                  'orderData': item,
                }
              );
            },
            child: OrderItemCard(
              imagePath: imagePath,
              title: title,
              subtitle: subtitle,
              description: description,
              status: item.status,
              isActive: isActive,
            ),
          );
        }
      },
    );
  });
}

Widget buildExtendRequestsList(
    BuildContext context, UserOrderController controller) {
  return Obx(() {
    if (controller.isLoading.value) {
      return const RectangleCardShimmer();
    }

    final extenTionsOrder = controller.customOrders
        .where((o) => o.extentionHistory.isNotEmpty)
        .toList();
    if (extenTionsOrder.isEmpty) {
      return LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: NotFound(
              icon: Icons.access_time,
              message: 'You have no extension requests at the moment.',
            ),
          ),
        ),
      );
    }
    return ListView.separated(
      itemCount: extenTionsOrder.length,
      separatorBuilder: (_, __) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        final item = extenTionsOrder[index];
        final lastExtention = item.extentionHistory.last;
        return GestureDetector(
          onTap: () {
            // Open extend history screen showing latest first (reverse the list)
            final reversedHistory = item.extentionHistory.reversed.toList();
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (_) => ExtendHistoryScreen(
                 
                  orderId: item.orderId,
                  history: reversedHistory,
                ),
              ),
            );
          },
          child: ExtendRequestCard(
            controller: controller,
            imagePath: item.designFiles.isNotEmpty
                ? item.designFiles.first
                : AppConstants.demoImage,
            orderId: item.orderId,
            lastDate: lastExtention.lastDate.toIso8601String().getDateTime(),
            proposeDate: lastExtention.newDate.toString().split(' ').first,
            requestedDays: lastExtention.newDate
                .difference(item.extentionHistory.last.lastDate)
                .inDays,
            status: lastExtention.status,
            onAccept: () async {
              final bool isSuccess = await controller.updateOrderExtention(
                  orderId: item.id, status: 'approved');

              if (isSuccess) {
                controller.fetchAllOrders();
                toastMessage(message: 'Request accepted');
              }
            },
            onCancel: () async {
              final bool isSuccess = await controller.updateOrderExtention(
                  orderId: item.id, status: 'rejected');
              if (isSuccess) {
                controller.fetchAllOrders();
                toastMessage(message: 'Request rejected');
              } else {
                toastMessage(message: 'Something went wrong');
              }
            },
          
          ),
        );
      },
    );
  });
}
