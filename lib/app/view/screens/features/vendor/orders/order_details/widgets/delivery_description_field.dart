import 'package:flutter/material.dart';
import 'package:local/app/view/screens/features/vendor/orders/controller/order_controller.dart';

class DeliveryDescriptionField extends StatelessWidget {
  final OrdersController controller;

  const DeliveryDescriptionField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller.descController,
        maxLines:3,
        decoration: InputDecoration(
          labelText: 'Description',
          labelStyle: TextStyle(color: Colors.blue.shade700),
          hintText: 'Enter delivery details...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(16),
          prefixIcon: Icon(
            Icons.description_outlined,
            color: Colors.blue.shade700,
          ),
        ),
      ),
    );
  }
}