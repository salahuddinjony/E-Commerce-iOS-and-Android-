import 'package:flutter/material.dart';
import 'package:local/app/global/helper/extension/extension.dart';
import 'package:local/app/view/screens/features/vendor/orders/constants/order_constants.dart';

class OrderCardTimeInfo extends StatelessWidget {
  final String status;
  final String? time;
  final Color primaryColor;

  const OrderCardTimeInfo({
    super.key,
    required this.status,
    required this.time,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    if (time == null) return const SizedBox.shrink();

    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 12,
          color: primaryColor.withValues(alpha: 0.8),
          fontWeight: FontWeight.w500,
        ),
        children: [
          TextSpan(text: '${OrderConstants.getStatusTimePrefix(status)}: '),
          TextSpan(
            text: time?.getDateTime() ?? '',
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
