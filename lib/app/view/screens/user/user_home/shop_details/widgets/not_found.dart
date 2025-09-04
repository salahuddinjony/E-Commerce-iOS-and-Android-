import 'package:flutter/material.dart';

class NotFound extends StatelessWidget {
  final String message;
  final IconData icon;
  const NotFound({super.key, required this.message, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.grey, size: 40),
          SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
