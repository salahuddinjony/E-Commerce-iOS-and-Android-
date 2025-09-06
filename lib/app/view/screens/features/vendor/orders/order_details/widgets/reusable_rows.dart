import 'package:flutter/material.dart';

class OrderDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const OrderDetailRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class DeliveryRouteItem extends StatelessWidget {
  final IconData iconData;
  final String label;
  final String value;

  const DeliveryRouteItem({
    super.key,
    required this.iconData,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final color = Colors.blue.shade300;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(iconData, color: color),
          const SizedBox(width: 8),
          Text('$label: ', style: TextStyle(color: color)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}