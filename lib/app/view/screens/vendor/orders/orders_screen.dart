import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_loader/custom_loader.dart';
import 'package:local/app/view/common_widgets/owner_nav/owner_nav.dart';
import 'controller/order_controller.dart';
import 'models/custom_order_response_model.dart';
import 'models/general_order_response_model.dart';

class OrdersScreen extends StatelessWidget {
  OrdersScreen({super.key});
  final OrdersController controller = Get.find<OrdersController>();

  Widget _buildCustomOrderCard(Order order, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with order ID and status
          Row(
            children: [
              Expanded(
                child: Text(
                  'Order: ${order.orderId}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(controller.getStatusColor(order.status)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  controller.getStatusDisplayText(order.status),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Order details
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Price', '${order.currency} ${order.price}'),
                    _buildDetailRow('Quantity', '${order.quantity}'),
                    _buildDetailRow('Type', 'Custom'),
                    if (order.deliveryDate != null)
                      _buildDetailRow('Delivery Date', 
                        '${order.deliveryDate!.day}/${order.deliveryDate!.month}/${order.deliveryDate!.year}'),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Payment', controller.getPaymentStatusDisplayText(order.paymentStatus)),
                    _buildDetailRow('Delivery', order.deliveryOption),
                    _buildDetailRow('Address', order.shippingAddress),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Summary
          if (order.summery.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                order.summery,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
              ),
            ),
          
          const SizedBox(height: 12),
          
          // Action button
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.brightCyan,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'View Details',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralOrderCard(GeneralOrder order, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with order ID and status
          Row(
            children: [
              Expanded(
                child: Text(
                  'Order: ${order.id.substring(0, 8)}...',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(controller.getGeneralOrderStatusColor(order.status)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  controller.getGeneralOrderStatusDisplayText(order.status),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Client and vendor info
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: order.clientImage != null 
                    ? NetworkImage(order.clientImage!) 
                    : null,
                child: order.clientImage == null 
                    ? Text(order.clientName[0].toUpperCase())
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Client: ${order.clientName}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Vendor: ${order.vendorName}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Order details
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Price', '${order.currency} ${order.price}'),
                    _buildDetailRow('Products', controller.getGeneralOrderSummary(order)),
                    _buildDetailRow('Date', controller.getGeneralOrderDateDisplay(order)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Payment', controller.getGeneralOrderPaymentStatusDisplayText(order.paymentStatus)),
                    _buildDetailRow('Address', order.shippingAddress),
                    if (controller.isRecentOrder(order))
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'New',
                          style: TextStyle(
                            color: Colors.green[800],
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.brightCyan,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'View Details',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
          onRefresh: () async => controller.refreshOrdersByType(true),
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return _buildCustomOrderCard(
                orders[index],
                () => controller.onCustomOrderTap(context, orders[index]),
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
          onRefresh: () async => controller.refreshOrdersByType(false),
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return _buildGeneralOrderCard(
                orders[index],
                () => controller.onGeneralOrderTap(context, orders[index]),
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
