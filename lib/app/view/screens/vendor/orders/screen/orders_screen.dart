import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_loader/custom_loader.dart';
import 'package:local/app/view/common_widgets/empty_state/empty_state_scrollable.dart';
import 'package:local/app/view/common_widgets/owner_nav/owner_nav.dart';
import 'package:local/app/view/screens/vendor/orders/models/custom_order_response_model.dart';
import 'package:local/app/view/screens/vendor/orders/models/general_order_response_model.dart';
import 'package:local/app/view/screens/vendor/orders/widgets/api_fialed_widget.dart';
import 'package:local/app/view/screens/vendor/orders/widgets/build_tab_content.dart';
import 'package:local/app/view/screens/vendor/orders/widgets/order_type_toggle.dart';
import 'package:local/app/view/screens/vendor/orders/widgets/orders_appbar.dart';
import '../controller/order_controller.dart';
import '../widgets/custom_order_card.dart';
import '../widgets/general_order_card.dart';

class OrdersScreen extends StatelessWidget {
  OrdersScreen({super.key});
  final OrdersController controller = Get.find<OrdersController>();

  // Widget buildTabContent(String tab) {
  //   return Obx(() {
  //     if (controller.isAnyLoading) {
  //       return const Center(child: CustomLoader());
  //     }

  //     if (controller.isAnyError) {
  //       return ApiFailedWidget<OrdersController>(
  //         controller: controller,
  //         combinedErrorMessage: controller.combinedErrorMessage,
  //         refreshOrders: () {
  //           controller.refreshOrders();
  //         },
  //       );
  //     }

  //     if (controller.isCustomOrder.value) {
  //       // Custom orders
  //       final orders = controller.getOrdersForTab(tab, true);

  //       return RefreshIndicator(
  //         color: AppColors.brightCyan,
  //         backgroundColor: Colors.white,
  //         onRefresh: () async => controller.refreshOrdersByType(true),
  //         child: orders.isEmpty
  //             ? EmptyStateScrollable(
  //                 message: 'No custom orders found for $tab',
  //               )
  //             : ListView.builder(
  //                 physics: const AlwaysScrollableScrollPhysics(),
  //                 padding: const EdgeInsets.only(top: 16),
  //                 itemCount: orders.length,
  //                 itemBuilder: (context, index) {
  //                   return CustomOrderCard(
  //                     order: orders[index],
  //                     controller: controller,
  //                     onTap: () =>
  //                         controller.onOrderTap<Order>(context, orders[index]),
  //                   );
  //                 },
  //               ),
  //       );
  //     } else {
  //       // General orders
  //       final orders = controller.getSortedGeneralOrdersForTab(tab);

  //       return RefreshIndicator(
  //         color: AppColors.brightCyan,
  //         backgroundColor: Colors.white,
  //         onRefresh: () async => controller.refreshOrdersByType(false),
  //         child: orders.isEmpty
  //             ? EmptyStateScrollable(
  //                 message: 'No general orders found for $tab',
  //               )
  //             : ListView.builder(
  //                 physics: const AlwaysScrollableScrollPhysics(),
  //                 padding: const EdgeInsets.only(top: 16),
  //                 itemCount: orders.length,
  //                 itemBuilder: (context, index) {
  //                   return GeneralOrderCard(
  //                     order: orders[index],
  //                     controller: controller,
  //                     onTap: () => controller.onOrderTap<GeneralOrder>(
  //                         context, orders[index]),
  //                   );
  //                 },
  //               ),
  //       );
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: const OwnerNav(currentIndex: 1),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: OrdersAppBar(controller: controller),
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // Toggle Switch
          OrderTypeToggle(controller: controller),

          // Tab Bar
          Obx(() => Container(
                color: Colors.white,
                child: TabBar(
                  key:
                      ValueKey(controller.isCustomOrder.value), // force rebuild
                  labelPadding: const EdgeInsets.only(right: 50),
                  isScrollable: true,
                  controller: controller.currentTabController,
                  labelColor: Colors.teal,
                  unselectedLabelColor: Colors.black,
                  indicatorColor: Colors.teal,
                  tabs:
                      controller.currentTabs.map((e) => Tab(text: e)).toList(),
                ),
              )),
          Obx(() => Expanded(
                child: TabBarView(
                  key: ValueKey(
                      'view-${controller.isCustomOrder.value}'), // ensure rebuild
                  controller: controller.currentTabController,
                  children: controller.currentTabs
                      .map((tab) => BuildTabContent(
                            controller: controller,
                            tab: tab,
                          ))
                      .toList(),
                ),
              )),
        ],
      ),
    );
  }
}
