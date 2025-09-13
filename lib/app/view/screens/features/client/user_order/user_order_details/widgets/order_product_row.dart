import 'package:flutter/material.dart';
import 'package:local/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:local/app/global/helper/extension/extension.dart';
import 'package:local/app/view/screens/features/vendor/orders/constants/order_constants.dart';

class OrderProductRow extends StatelessWidget {
  final String imageUrl;
  final String orderID;
  final String orderStatus;
  final bool isCustom;
  final String orderDate;

  const OrderProductRow({
    super.key,
    required this.imageUrl,
    required this.orderID,
    required this.orderStatus,
    required this.isCustom,
    required this.orderDate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomNetworkImage(
          imageUrl: imageUrl,
          height: 100,
          width: 100,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '#$orderID',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black),
                  children: [
                    const TextSpan(text: 'Status : '),
                    TextSpan(
                      text: orderStatus.capitalizeFirstWord(),
                      style: TextStyle(
                        color:
                            Color(OrderConstants.getStatusColor(orderStatus)),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black),
                  children: [
                    const TextSpan(text: 'Order Type : '),
                    TextSpan(
                      text: isCustom ? 'Custom Order' : 'General Order',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text('Placed on: $orderDate',
                  style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }
}
