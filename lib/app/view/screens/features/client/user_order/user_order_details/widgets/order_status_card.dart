import 'package:flutter/material.dart';
import 'package:local/app/global/helper/extension/extension.dart';
import 'package:local/app/view/screens/features/vendor/orders/constants/order_constants.dart';

class OrderStatusCard extends StatelessWidget {
  final String status;
  final String? time;
  final String? message;

  const OrderStatusCard({
    super.key,
    required this.status,
    this.time,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final normalizedStatus = status.toLowerCase();

    // Don't show card for statuses that have action cards
    if (OrderConstants.shouldHideStatusCard(normalizedStatus)) {
      return const SizedBox.shrink();
    }

    final colorGroup = OrderConstants.getStatusColorGroup(normalizedStatus);
    final primaryColor =
        Color(OrderConstants.getPrimaryColorByGroup(colorGroup));
    final lightColor = Color(OrderConstants.getLightColorByGroup(colorGroup));
    final extraLightColor =
        Color(OrderConstants.getExtraLightColorByGroup(colorGroup));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [extraLightColor, lightColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: lightColor,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: lightColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: primaryColor,
                  width: 2,
                ),
              ),
              child: Icon(
                OrderConstants.getStatusIcon(normalizedStatus),
                color: primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    OrderConstants.getStatusTitle(normalizedStatus),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    message ??
                        OrderConstants.getStatusDescription(normalizedStatus),
                    style: TextStyle(
                      fontSize: 14,
                      color: primaryColor.withValues(alpha: 0.8),
                      height: 1.3,
                    ),
                  ),
                  if (time != null) ...[
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 12,
                          color: primaryColor.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          TextSpan(
                              text:
                                  '${OrderConstants.getStatusTimePrefix(normalizedStatus)}: '),
                          TextSpan(
                            text: time?.getDateTime() ?? '',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
