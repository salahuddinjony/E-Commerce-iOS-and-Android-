import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:shimmer/shimmer.dart';
import '../models/general_order_response_model.dart';
import '../controller/order_controller.dart';
import 'order_detail_row.dart';

class GeneralOrderCard extends StatelessWidget {
  final GeneralOrder order;
  final OrdersController controller;
  final VoidCallback onTap;

  const GeneralOrderCard({
    super.key,
    required this.order,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String safeFirstLetter(String? v) =>
        (v != null && v.isNotEmpty) ? v[0].toUpperCase() : '?';

    String safeIdShort(String v) =>
        (v.length > 8) ? '${v.substring(0, 8)}...' : v;

    final clientName = (order.clientName.isNotEmpty) ? order.clientName : 'Unknown';
    final vendorName = (order.vendorName.isNotEmpty) ? order.vendorName : 'Unknown Vendor';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: .1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Text(
                  'Order: ${safeIdShort(order.id)}',
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
          // Client & Vendor
          Row(
            children: [
              // Avatar with cached image
              SizedBox(
                width: 40,
                height: 40,
                child: ClipOval(
                  child: (order.clientImage != null && order.clientImage!.isNotEmpty)
                      ? CachedNetworkImage(
                          imageUrl: order.clientImage!,
                          fit: BoxFit.cover,
                          placeholder: (ctx, _) => Container(
                            color: Colors.grey.shade200,
                            alignment: Alignment.center,
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                              width: 40,
                              height: 40,
                              color: Colors.grey.shade300,
                              ),
                            ),
                          ),
                          errorWidget: (ctx, _, __) => Container(
                            color: Colors.grey.shade300,
                            alignment: Alignment.center,
                            child: Text(
                              safeFirstLetter(clientName),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          color: Colors.grey.shade300,
                          alignment: Alignment.center,
                          child: Text(
                            safeFirstLetter(clientName),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Client: $clientName',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Vendor: $vendorName',
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
          // Row 1: Price + Payment
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
          // Row 2: Products + Date
          Row(
            children: [
              Expanded(
                child: OrderDetailRow(
                  label: 'Products',
                  value: controller.getOrderSummary<GeneralOrder>(order),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OrderDetailRow(
                  label: 'Date',
                  value: controller.getOrderDateDisplay<GeneralOrder>(order),
                ),
              ),
            ],
          ),
          if (controller.isRecentOrder<GeneralOrder>(order)) ...[
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
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
            ),
          ],
          const SizedBox(height: 12),
          // Action
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
