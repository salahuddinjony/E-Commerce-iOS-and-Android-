import 'package:flutter/material.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import '../models/custom_order_response_model.dart';
import '../controller/order_controller.dart';
import 'order_detail_row.dart';

class CustomOrderCard extends StatelessWidget {
  final Order order;
  final OrdersController controller;
  final VoidCallback onTap;

  const CustomOrderCard({
    super.key,
    required this.order,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: .1),
            spreadRadius: 30,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          // Two horizontal rows: (Price + Payment) and (Quantity + Delivery/Date)
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: OrderDetailRow(
                      label: 'Price',
                      value: '${order.currency} ${order.price}',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OrderDetailRow(
                      label: 'Payment',
                      value: controller.getPaymentStatusDisplayText(order.paymentStatus),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: OrderDetailRow(
                      label: 'Quantity',
                      value: '${order.quantity}',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OrderDetailRow(
                      label: 'Delivery',
                      value: order.deliveryOption,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Expanded(
                    child: OrderDetailRow(label: 'Type', value: 'Custom'),
                  ),
                  if (order.deliveryDate != null) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: OrderDetailRow(
                        label: 'Delivery Date',
                        value: controller.getOrderDateDisplay<Order>(order),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
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
}
