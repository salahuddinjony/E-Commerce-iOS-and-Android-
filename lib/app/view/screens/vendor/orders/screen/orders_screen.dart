import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_loader/custom_loader.dart';
import 'package:local/app/view/common_widgets/owner_nav/owner_nav.dart';
import '../controller/order_controller.dart';
import '../widgets/custom_order_card.dart';
import '../widgets/general_order_card.dart';

class OrdersScreen extends StatelessWidget {
  OrdersScreen({super.key});
  final OrdersController controller = Get.find<OrdersController>();

  // Order cards are now separate widgets under widgets/ directory.

  Widget _buildTabContent(String tab) {
    return Obx(() {
      if (controller.isAnyLoading) {
        return const Center(child: CustomLoader());
      }

      if (controller.isAnyError) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                controller.combinedErrorMessage,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: controller.refreshOrders,
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      if (controller.isCustomOrder.value) {
        // Custom orders
        final orders = controller.getOrdersForTab(tab, true);
        
        if (orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No custom orders found for $tab',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: AppColors.brightCyan,
          backgroundColor: Colors.white,
          onRefresh: () async => controller.refreshOrdersByType(true),
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return CustomOrderCard(
                order: orders[index],
                controller: controller,
                onTap: () => controller.onCustomOrderTap(context, orders[index]),
              );
            },
          ),
        );
      } else {
        // General orders
        final orders = controller.getSortedGeneralOrdersForTab(tab);
        
        if (orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No general orders found for $tab',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: AppColors.brightCyan,
          backgroundColor: Colors.white,
          onRefresh: () async => controller.refreshOrdersByType(false),
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return GeneralOrderCard(
                order: orders[index],
                controller: controller,
                onTap: () => controller.onGeneralOrderTap(context, orders[index]),
              );
            },
          ),
        );
      }
    });
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      checkmarkColor: Colors.white,
                      label: const Text('General Orders'),
                      selected: !controller.isCustomOrder.value,
                      onSelected: (val) {
                        controller.isCustomOrder.value = false;
                        controller.refreshOrdersByType(false);
                      },
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
                      onSelected: (val) {
                        controller.isCustomOrder.value = true;
                        controller.refreshOrdersByType(true);
                      },
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
