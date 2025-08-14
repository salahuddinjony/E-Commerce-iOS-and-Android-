import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/owner_nav/owner_nav.dart';
import 'controller/order_controller.dart';

class OrdersScreen extends StatelessWidget {
  OrdersScreen({super.key});
  final OrdersController controller = Get.find<OrdersController>();

  Widget _buildOrderCard(Map<String, String> order, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(order['imageUrl']!),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(order['name']!,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const Spacer(),
                    Text('Parcel ID:${order['parcelId']}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text('Your Order Number:',
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                    const Spacer(),
                    Text(order['orderNumber']!,
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(order['locationLine1']!,
                        style: const TextStyle(color: Colors.grey)),
                    const Spacer(),
                    GestureDetector(
                      onTap: onTap,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.teal[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('Pending',
                            style: TextStyle(color: Colors.white)),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 15.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(String tab) {
    List<Map<String, String>> orders;

    if (controller.isCustomOrder.value) {
      // Custom orders
      if (tab == 'Pending') {
        orders = controller.pendingCustomOrders;
      } else {
        orders = []; // Replace with other custom order data if available
      }
    } else {
      // General orders
      switch (tab) {
        case 'All Orders':
          orders = controller
              .pendingGeneralOrders; // combine all general orders here
          break;
        case 'Pending':
          orders = controller.pendingGeneralOrders;
          break;
        case 'Completed':
          orders = []; // Add completed orders data
          break;
        case 'Rejected':
          orders = []; // Add rejected orders data
          break;
        default:
          orders = [];
      }
    }

    if (orders.isEmpty) {
      return Center(child: Text('No orders for $tab'));
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return _buildOrderCard(
          orders[index],
          () => controller.onPendingOrderTap(context),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: const OwnerNav(currentIndex: 1),
      appBar: const CustomAppBar(appBarContent: AppStrings.order),
      body: Column(
        children: [
          // Toggle Switch
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical:0),
            child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      checkmarkColor: Colors.white,
                      label: const Text('General Orders'),
                      selected: !controller.isCustomOrder.value,
                      onSelected: (val) =>
                          controller.isCustomOrder.value = false,
                      selectedColor: AppColors.brightCyan,
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: !controller.isCustomOrder.value
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      checkmarkColor: Colors.white,
                      label: const Text('Custom Orders'),
                      selected: controller.isCustomOrder.value,
                      onSelected: (val) =>
                          controller.isCustomOrder.value = true,
                      selectedColor: AppColors.brightCyan,
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: controller.isCustomOrder.value
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )),
          ),

          // Tab Bar
          Obx(() => Container(
                color: Colors.white,
                child: TabBar(
                  labelPadding: const EdgeInsets.only(right: 50),
                  isScrollable: true,
                  controller: controller.tabController,
                  labelColor: Colors.teal,
                  unselectedLabelColor: Colors.black,
                  indicatorColor: Colors.teal,
                  tabs: controller.tabs.map((e) => Tab(text: e)).toList(),
                ),
              )),
          // Tab Content
          Obx(() => Expanded(
                child: TabBarView(
                  controller: controller.tabController,
                  children: controller.tabs
                      .map((tab) => _buildTabContent(tab))
                      .toList(),
                ),
              )),
        ],
      ),
    );
  }
}
