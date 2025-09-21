import 'package:flutter/material.dart';

class CustomOrderField extends StatelessWidget {
  final controller;
  const CustomOrderField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Price', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller.priceController,
          decoration: InputDecoration(
            hintText: 'Price',
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller.quantityController,
          decoration: InputDecoration(
            hintText: 'Quantity',
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const Text('Delivery Option',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller.deliveryOptionController,
          decoration: InputDecoration(
            hintText: 'Ex: Courier, Home Delivery',
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text('Delivery Date',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller.deliveryDate,
          decoration: InputDecoration(
            hintText: 'Delivery Date',
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 16),

        const Text('Summery Of the Order',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller.summeryController,
          decoration: InputDecoration(
            hintText: 'Summery Of the Order',
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
