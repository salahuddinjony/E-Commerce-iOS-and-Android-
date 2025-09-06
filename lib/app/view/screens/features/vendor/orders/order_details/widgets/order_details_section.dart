import 'package:flutter/material.dart';
import '../../constants/order_constants.dart';
import '../../models/custom_order_response_model.dart';
import '../../models/general_order_response_model.dart';
import 'reusable_rows.dart';
import 'design_files_gallery.dart';

class OrderDetailsSection extends StatelessWidget {
  final bool isCustomOrder;
  final dynamic orderData;

  const OrderDetailsSection({
    super.key,
    required this.isCustomOrder,
    required this.orderData,
  });

  @override
  Widget build(BuildContext context) {
    if (isCustomOrder) {
      final order = orderData as Order;
      return Column(
        children: [
          OrderDetailRow(label: 'Order ID', value: order.orderId),
          const OrderDetailRow(label: 'Type', value: 'Custom Order'),
          OrderDetailRow(label: 'Client Id', value: order.client.toString()),
          OrderDetailRow(label: 'Price', value: '${order.currency} ${order.price}'),
            OrderDetailRow(label: 'Quantity', value: '${order.quantity}'),
          OrderDetailRow(
            label: 'Payment Status',
            value: OrderConstants.getPaymentStatusDisplayText(order.paymentStatus),
          ),
          OrderDetailRow(label: 'Delivery Option', value: order.deliveryOption),
          if (order.deliveryDate != null)
            OrderDetailRow(
              label: 'Delivery Date',
              value:
                  '${order.deliveryDate!.day}/${order.deliveryDate!.month}/${order.deliveryDate!.year}',
            ),
          OrderDetailRow(label: 'Shipping Address', value: order.shippingAddress),
          if (order.summery.isNotEmpty)
            OrderDetailRow(label: 'Summary', value: order.summery),
          DesignFilesGallery(files: order.designFiles),
        ],
      );
    } else {
      final order = orderData as GeneralOrder;
      return Column(
        children: [
          OrderDetailRow(label: 'Order ID', value: order.id.substring(0, 8)),
          const OrderDetailRow(label: 'Type', value: 'General Order'),
          OrderDetailRow(label: 'Client', value: order.clientName),
          OrderDetailRow(label: 'Vendor', value: order.vendorName),
          OrderDetailRow(label: 'Price', value: '${order.currency} ${order.price}'),
          OrderDetailRow(
            label: 'Products',
            value: '${order.products.length} products, ${order.totalQuantity} items',
          ),
          OrderDetailRow(
            label: 'Payment Status',
            value: OrderConstants.getPaymentStatusDisplayText(order.paymentStatus),
          ),
          OrderDetailRow(label: 'Shipping Address', value: order.shippingAddress),
        ],
      );
    }
  }
}