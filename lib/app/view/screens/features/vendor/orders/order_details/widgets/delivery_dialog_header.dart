import 'package:flutter/material.dart';

class DeliveryDialogHeader extends StatelessWidget {
  const DeliveryDialogHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.local_shipping_rounded,
            size: 32,
            color: Colors.blue.shade700,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Delivery Request',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Please provide details for the delivery request',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}