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

// Custom Order
Widget buildCustomOrdersList(
    BuildContext context, UserOrderController controller) {
  return Obx(() {
    if (controller.isLoading.value) {
      return const RectangleCardShimmer();
    }

    final customOrders = controller.customOrders;
    if (customOrders.isEmpty) {
      return LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: NotFound(
              icon: Icons.design_services_outlined,
              message: 'You have no custom orders at the moment.',
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: controller.customOrdersScrollController,
      itemCount: customOrders.length + (controller.customIsPaginating.value ? 1 : 0),
      separatorBuilder: (_, __) => SizedBox(height: 8.h),
      itemBuilder: (context, index) {
        // Show loading indicator at the end while paginating
        if (index == customOrders.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        final item = customOrders[index];
        final imagePath = (item.designFiles.isNotEmpty)
            ? item.designFiles.first
            : AppConstants.demoImage;
        final orderId = item.orderId;
        final createdDate = item.createdAt.toIso8601String().getDateTime();
        final description = item.summery;
        final isActive = true;
        final price = item.price;

        return GestureDetector(
          onTap: () {
            context.pushNamed(RoutePath.userOrderDetailsScreen,
            extra: {
              'isCustom': true,
              'orderData': item,
              'controller': controller,
            });
          },
          child: OrderItemCard(
            imagePath: imagePath,
            orderid: orderId,
            createdDate: createdDate,
            description: description,
            status: item.status,
            isActive: isActive,
            price: price.toString(),
          ),
        );
      },
    );
  });
}

//General Order
Widget buildGeneralOrdersList(
    BuildContext context, UserOrderController controller) {
  return Obx(() {
    if (controller.isGeneralOrdersLoading.value) {
      return const RectangleCardShimmer();
    }

    final generalOrders = controller.generalOrdersList;
    if (generalOrders.isEmpty) {
      return LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: NotFound(
              icon: Icons.shopping_bag_outlined,
              message: 'You have no general orders at the moment.',
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: controller.generalOrdersScrollController,
      itemCount: generalOrders.length + (controller.generalIsPaginating.value ? 1 : 0),
      separatorBuilder: (_, __) => SizedBox(height: 8.h),
      itemBuilder: (context, index) {
        // Show loading indicator at the end while paginating
        if (index == generalOrders.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        final item = generalOrders[index];
        String imagePath = item.products.first.productId?.images.first ??
            AppConstants.demoImage;
        final orderId = item.products.first.productId?.name;
        final createdDate = item.createdAt.formatDate();
        final shippingAddress = item.shippingAddress;
        final isActive = true;
        final price = item.price;

        return GestureDetector(
          onTap: () {
            context.pushNamed(RoutePath.userOrderDetailsScreen, extra: {
              'isCustom': false,
              'orderData': item,
              'controller': controller,
            });
          },
          child: OrderItemCard(
            imagePath: imagePath,
            orderid: orderId ?? '',
            createdDate: createdDate,
            description: shippingAddress,
            isActive: isActive,
            status: item.status,
            price: price.toString(),
          ),
        );
      },
    );
  });
}

//Extension Order Request
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
            lastDate: lastExtention.lastDate.formatDate(),
            proposeDate: lastExtention.newDate.formatDate(),
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
