import 'package:flutter/material.dart';
import 'package:local/app/view/screens/features/vendor/orders/constants/order_constants.dart';

class OrderCardDescription extends StatelessWidget {
  final String status;
  final bool hasActions;
  final Color primaryColor;
  final String? message;

  const OrderCardDescription({
    super.key,
    required this.status,
    required this.hasActions,
    required this.primaryColor,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final String description = hasActions
        ? OrderConstants.getActionCardDescription(status)
        : (message ?? OrderConstants.getStatusDescription(status));

    return Text(
      description,
      style: TextStyle(
        fontSize: 14,
        color: primaryColor.withValues(alpha: 0.8),
        height: hasActions ? 1.4 : 1.3,
      ),
    );
  }
}
