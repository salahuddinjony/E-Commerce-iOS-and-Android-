import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/global/helper/toast_message/toast_message.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/screens/vendor/orders/controller/order_controller.dart';
import '../models/custom_order_response_model.dart';
import '../models/general_order_response_model.dart';
import '../constants/order_constants.dart';

class OrderDetailsScreen extends StatelessWidget {
  final dynamic orderData; // Can be either Order or GeneralOrder
  final bool isCustomOrder;
  final OrdersController controller;

  const OrderDetailsScreen({
    super.key,
    required this.orderData,
    required this.isCustomOrder,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('${isCustomOrder ? 'Custom' : 'General'} Order Details'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header with Status
            _buildOrderHeader(),
            const SizedBox(height: 24),

            // Order Details Section
            const Text(
              'Order Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            _buildOrderDetails(),
            const SizedBox(height: 20),

            // Date & Price Row
            _buildDatePriceRow(),
            const SizedBox(height: 24),

            // Delivery Route Section
            const Text(
              'Delivery Route',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            _buildDeliveryRoute(),
            SizedBox(height: 50.h),

            // Action Buttons
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderHeader() {
    String orderId = '';
    String status = '';
    int statusColor = 0xFF757575; // Default grey color

    if (isCustomOrder) {
      final order = orderData as Order;
      orderId = order.orderId;
      status = OrderConstants.getStatusDisplayText(order.status);
      statusColor = OrderConstants.getStatusColor(order.status);
    } else {
      final order = orderData as GeneralOrder;
      orderId = order.id.substring(0, 8);
      status = OrderConstants.getStatusDisplayText(order.status);
      statusColor = OrderConstants.getStatusColor(order.status);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order ID: $orderId',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Status: $status',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Color(statusColor),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetails() {
    if (isCustomOrder) {
      final order = orderData as Order;
      return Column(
        children: [
          OrderDetailRow(label: 'Order ID', value: order.orderId),
          OrderDetailRow(label: 'Type', value: 'Custom Order'),
          OrderDetailRow(label: 'Price', value: '${order.currency} ${order.price}'),
          OrderDetailRow(label: 'Quantity', value: '${order.quantity}'),
          OrderDetailRow(label: 'Payment Status', value: OrderConstants.getPaymentStatusDisplayText(order.paymentStatus)),
          OrderDetailRow(label: 'Delivery Option', value: order.deliveryOption),
          if (order.deliveryDate != null)
            OrderDetailRow(
              label: 'Delivery Date', 
              value: '${order.deliveryDate!.day}/${order.deliveryDate!.month}/${order.deliveryDate!.year}'
            ),
          OrderDetailRow(label: 'Shipping Address', value: order.shippingAddress),
          if (order.summery.isNotEmpty)
            OrderDetailRow(label: 'Summary', value: order.summery),
        ],
      );
    } else {
      final order = orderData as GeneralOrder;
      return Column(
        children: [
          OrderDetailRow(label: 'Order ID', value: order.id.substring(0, 8)),
          OrderDetailRow(label: 'Type', value: 'General Order'),
          OrderDetailRow(label: 'Client', value: order.clientName),
          OrderDetailRow(label: 'Vendor', value: order.vendorName),
          OrderDetailRow(label: 'Price', value: '${order.currency} ${order.price}'),
          OrderDetailRow(label: 'Products', value: '${order.products.length} products, ${order.totalQuantity} items'),
          OrderDetailRow(label: 'Payment Status', value: OrderConstants.getPaymentStatusDisplayText(order.paymentStatus)),
          OrderDetailRow(label: 'Shipping Address', value: order.shippingAddress),
        ],
      );
    }
  }

  Widget _buildDatePriceRow() {
    String date = '';
    String price = '';

    if (isCustomOrder) {
      final order = orderData as Order;
      date = '${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}';
      price = '${order.currency} ${order.price}';
    } else {
      final order = orderData as GeneralOrder;
      date = '${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}';
      price = '${order.currency} ${order.price}';
    }

    return Container(
      color: Colors.grey.shade200,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(date, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(price, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildDeliveryRoute() {
    if (isCustomOrder) {
      final order = orderData as Order;
      return Column(
        children: [
          DeliveryRouteItem(
            iconData: Icons.store,
            label: 'Vendor',
            value: 'U Tee Hub Store',
          ),
          DeliveryRouteItem(
            iconData: Icons.location_on_outlined,
            label: 'Drop-off',
            value: order.shippingAddress,
          ),
        ],
      );
    } else {
      final order = orderData as GeneralOrder;
      return Column(
        children: [
          DeliveryRouteItem(
            iconData: Icons.store,
            label: 'Vendor',
            value: order.vendorName,
          ),
          DeliveryRouteItem(
            iconData: Icons.location_on_outlined,
            label: 'Drop-off',
            value: order.shippingAddress,
          ),
        ],
      );
    }
  }

  Widget _buildActionButtons(BuildContext context) {
    if (isCustomOrder) {
      final order = orderData as Order;
      // Show action buttons based on order status
      if (order.status == 'offered' || order.status == 'pending') {
        return Row(
          children: [
            Expanded(
              flex: 5,
              child: CustomButton(
                onTap: () async {

                  if (await controller.updateCustomOrderStatus(order.id, 'completed')) {
                    await controller.updateCustomOrderStatus(order.id, 'completed');
                    toastMessage(message: 'Custom Order Approved');
                    context.pop();
                  }else {
                    toastMessage(message: 'Failed to approve order');
                  }
                },
                title: "Approve",
                isRadius: true,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              flex: 5,
              child: CustomButton(
                fillColor: Colors.red,
                onTap: () async {
                  if (await controller.updateCustomOrderStatus(order.id, 'completed')) {
                    toastMessage(message: 'Custom Order Approved');
                    context.pop();
                  }else {
                    toastMessage(message: 'Failed to approve order');
                  }
                },
                title: "Reject",
                isRadius: true,
              ),
            ),
          ],
        );
      } else {
        return CustomButton(
          onTap: () => context.pop(),
          title: "Back",
          isRadius: true,
        );
      }
    } else {
      final order = orderData as GeneralOrder;
      // Show action buttons based on order status
      if (order.status == 'offered' || order.status == 'pending') {
        return Row(
          children: [
            Expanded(
              flex: 5,
              child: CustomButton(
                onTap: () {
                 
                  toastMessage(message: 'General Order Approved');
                  context.pop();
                },
                title: "Approve",
                isRadius: true,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              flex: 5,
              child: CustomButton(
                fillColor: Colors.red,
                onTap: () async {
                  if (await controller.deleteGeneralOrder(order.id)) {
                    toastMessage(message: 'General Order Deleted');
                    context.pop();
                  } else {
                    toastMessage(message: 'Failed to delete order');
                  }
                },
                title: "Reject",
                isRadius: true,
              ),
            ),
          ],
        );
      } else {
        return CustomButton(
          onTap: () => context.pop(),
          title: "Back",
          isRadius: true,
        );
      }
    }
  }
}

class OrderDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const OrderDetailRow({required this.label, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label: ',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class DeliveryRouteItem extends StatelessWidget {
  final IconData iconData;
  final String label;
  final String value;

  const DeliveryRouteItem({
    required this.iconData,
    required this.label,
    required this.value,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Colors.blue.shade300;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(iconData, color: color),
          const SizedBox(width: 8),
          Text('$label: ', style: TextStyle(color: color)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
