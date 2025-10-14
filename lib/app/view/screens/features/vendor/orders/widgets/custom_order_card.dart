import 'package:flutter/material.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/global/helper/extension/extension.dart';
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                      value: '\$${order.price}',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OrderDetailRow(
                      label: 'Payment',
                      value: controller
                          .getPaymentStatusDisplayText(order.paymentStatus),
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
                      label: 'Delivery Option',
                      value: order.deliveryOption,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: OrderDetailRow(
                      label: 'Payment Status',
                      value: order.paymentStatus.capitalizeFirstWord(),
                    ),
                  ),
                  if (order.deliveryDate != null) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: OrderDetailRow(
                        label: 'Order Date',
                        value: controller.getOrderDateDisplay<Order>(order),
                        valueStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              order.status.toLowerCase() == 'offered' ||
                      order.status.toLowerCase() == 'pending' ||
                      order.status.toLowerCase() == 'in-progress'
                  ? Card(
                      elevation: 0.1,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 3),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            StreamBuilder<String>(
                              stream: controller.countdownStream(
                                  order.createdAt, order.deliveryDate!),
                              builder: (context, snapshot) {
                                final value = snapshot.data ?? "";
                                final isExpired = value == 'Expired';

                                return Row(
                                  children: [
                                    Icon(
                                      isExpired
                                          ? Icons.warning
                                          : Icons.delivery_dining,
                                      color:
                                          isExpired ? Colors.red : Colors.black,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      value,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: isExpired
                                            ? Colors.red
                                            : Colors.blue,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  : SizedBox.shrink()
            ],
          ),
          const SizedBox(height: 12),
          // if (order.summery.isNotEmpty)
          //   Container(
          //     width: double.infinity,
          //     padding: const EdgeInsets.all(12),
          //     decoration: BoxDecoration(
          //       color: Colors.grey[50],
          //       borderRadius: BorderRadius.circular(8),
          //     ),
          //     child: Text(
          //       order.summery,
          //       style: TextStyle(
          //         color: Colors.grey[700],
          //         fontSize: 14,
          //       ),
          //     ),
          //   ),
          // const SizedBox(height: 5),
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
