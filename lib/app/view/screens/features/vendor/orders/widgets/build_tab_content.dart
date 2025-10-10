import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/empty_state/empty_state_scrollable.dart';
import 'package:local/app/view/screens/features/vendor/orders/controller/order_controller.dart';
import 'package:local/app/view/screens/features/vendor/orders/models/custom_order_response_model.dart';
import 'package:local/app/view/screens/features/vendor/orders/models/general_order_response_model.dart';
import 'package:local/app/view/screens/features/vendor/orders/widgets/api_fialed_widget.dart';
import 'package:local/app/view/screens/features/vendor/orders/widgets/custom_order_card.dart';
import 'package:local/app/view/screens/features/vendor/orders/widgets/general_order_card.dart';
import 'package:local/app/view/screens/features/vendor/orders/widgets/shimmer_order_card.dart';
import 'package:local/app/view/screens/features/vendor/orders/widgets/orders_data_loader.dart';


class BuildTabContent extends StatelessWidget {
  final OrdersController controller;
  final String tab;
  const BuildTabContent({super.key, required this.controller, required this.tab});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isAnyLoading) {
        return  ListView.builder(
          itemCount: 6,
          
          itemBuilder:(context, index) {
            return  ShimmerOrderCard();
          },
        );
      }

      if (controller.isAnyError) {
        return ApiFailedWidget<OrdersController>(
          controller: controller,
            combinedErrorMessage: controller.combinedErrorMessage,
          refreshOrders: () {
            controller.refreshOrders();
          },
        );
      }

      if (controller.isCustomOrder.value) {
        // Custom orders
        final orders = controller.getOrdersForTab(tab, true);

        return RefreshIndicator(
          color: AppColors.brightCyan,
          backgroundColor: Colors.white,
          onRefresh: () async => controller.refreshOrdersByType(true),
          child: orders.isEmpty
              ? EmptyStateScrollable(
                  message: 'No custom orders found for $tab',
                )
              : NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    // Additional scroll detection for better reliability
                    if (scrollInfo is ScrollEndNotification) {
                      final pixels = scrollInfo.metrics.pixels;
                      final maxExtent = scrollInfo.metrics.maxScrollExtent;
                      if (pixels >= maxExtent * 0.5 && // Lowered to 50% for easier testing
                          controller.isCustomOrder.value &&
                          !controller.isPaginating.value &&
                          controller.hasMoreData.value) {
                        print('ScrollEndNotification - triggering pagination at 50%');
                        controller.isPaginating.value = true;
                        controller.getMoreOrders();
                      }
                    }
                    return false;
                  },
                  child: ListView.builder(
                    controller: controller.scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(top: 16),
                    itemCount: orders.length + (controller.hasMoreData.value || controller.isPaginating.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == orders.length) {
                        return showOrdersDataLoader(controller);
                      }
                      return CustomOrderCard(
                        order: orders[index],
                        controller: controller,
                        onTap: () =>
                            controller.onOrderTap<Order>(context, orders[index]),
                      );
                    },
                  ),
                ),
        );
      } else {
        // General orders
        final orders = controller.getSortedGeneralOrdersForTab(tab);

        return RefreshIndicator(
          color: AppColors.brightCyan,
          backgroundColor: Colors.white,
          onRefresh: () async => controller.refreshOrdersByType(false),
          child: orders.isEmpty
              ? EmptyStateScrollable(
                  message: 'No general orders found for $tab',
                )
              : ListView.builder(
                  controller: controller.scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(top: 16),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    return GeneralOrderCard(
                      order: orders[index],
                      controller: controller,
                      onTap: () => controller.onOrderTap<GeneralOrder>(
                          context, orders[index]),
                    );
                  },
                ),
        );
      }
    });
  }
}