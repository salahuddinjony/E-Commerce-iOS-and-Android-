import 'package:flutter/material.dart';

  Widget EmptyState({required IconData icon, required String text}) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            text,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }