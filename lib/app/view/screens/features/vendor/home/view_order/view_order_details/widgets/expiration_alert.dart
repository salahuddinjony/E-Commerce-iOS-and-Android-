import 'package:flutter/material.dart';

class ExpirationAlert extends StatelessWidget {
  final bool isNotExpired;
  const ExpirationAlert({super.key, required this.isNotExpired});

  @override
  Widget build(BuildContext context) {
    if (isNotExpired) return const SizedBox.shrink();
    return Center(
      child: Card(
        elevation: 1,
        color: Colors.red[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Colors.red,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            "The delivery date has passed!",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
