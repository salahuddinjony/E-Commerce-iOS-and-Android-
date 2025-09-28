import 'package:flutter/material.dart';
import 'package:local/app/view/screens/features/vendor/orders/constants/order_constants.dart';

class OrderCardHeader extends StatelessWidget {
  final String status;
  final bool hasActions;
  final Color primaryColor;

  const OrderCardHeader({
    super.key,
    required this.status,
    required this.hasActions,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final IconData iconData = hasActions
        ? OrderConstants.getActionCardIcon(status)
        : OrderConstants.getStatusIcon(status);

    final String title = hasActions
        ? OrderConstants.getActionCardTitle(status)
        : OrderConstants.getStatusTitle(status);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: primaryColor.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Icon(
            iconData,
            color: primaryColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: hasActions ? 18 : 16,
              color: primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
