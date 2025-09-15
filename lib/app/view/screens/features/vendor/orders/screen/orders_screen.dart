import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/bottom_navigation_bar/vendor_nav/vendor_nav.dart';
import 'package:local/app/view/screens/features/vendor/orders/widgets/build_tab_content.dart';
import 'package:local/app/view/screens/features/vendor/orders/widgets/order_type_toggle.dart';
import 'package:local/app/view/screens/features/vendor/orders/widgets/orders_appbar.dart';
import '../controller/order_controller.dart';

class OrdersScreen extends StatelessWidget {
  OrdersScreen({super.key});
  final OrdersController controller = Get.find<OrdersController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: OwnerNav(currentIndex: 1),
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
