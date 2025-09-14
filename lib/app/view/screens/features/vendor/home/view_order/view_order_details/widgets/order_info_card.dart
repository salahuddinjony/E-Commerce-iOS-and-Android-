import 'package:flutter/material.dart';
import 'package:local/app/global/helper/extension/extension.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/screens/features/vendor/home/view_order/view_order_details/widgets/order_filed.dart';
import 'package:local/app/view/screens/features/vendor/orders/models/custom_order_response_model.dart';

class OrderInfoCard extends StatelessWidget {
  final Order order;
  const OrderInfoCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(
          color: AppColors.brightCyan,
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrderField(label: "Order ID", value: order.id.toString()),
            OrderField(label: "Client", value: (order.client).toString()),
            OrderField(label: "Status", value: order.status),
            OrderField(
                label: "Price", value: '\$' + (order.price).toStringAsFixed(0)),
            OrderField(
                label: "Created",
                value: order.createdAt.toIso8601String().getDateTime()),
            OrderField(label: "Delivery Date", value: order.deliveryDate!.formatDate()),
          ],
        ),
      ),
    );
  }
}