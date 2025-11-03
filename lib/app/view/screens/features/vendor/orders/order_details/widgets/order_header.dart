import 'package:flutter/material.dart';
import '../../constants/order_constants.dart';
import '../../models/custom_order_response_model.dart';
import '../../models/general_order_response_model.dart';

class OrderHeader extends StatelessWidget {
  final bool isCustomOrder;
  final dynamic orderData;

  const OrderHeader({
    super.key,
    required this.isCustomOrder,
    required this.orderData,
  });

  @override
  Widget build(BuildContext context) {
    String orderId;
    String status;
    int statusColor;

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
                  'Order ID: ${orderId.replaceFirst('ORD-', '')}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Status: $status',
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
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
}