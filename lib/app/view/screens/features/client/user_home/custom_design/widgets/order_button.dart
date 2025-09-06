import 'package:flutter/material.dart';

class OrderButton extends StatelessWidget {
  final VoidCallback onTap;
  const OrderButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: onTap,
            icon: const Icon(Icons.shopping_bag_outlined),
            label: const Text("Order Now", style: TextStyle(fontSize: 16)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1FC4B8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      ),
    );
  }
}