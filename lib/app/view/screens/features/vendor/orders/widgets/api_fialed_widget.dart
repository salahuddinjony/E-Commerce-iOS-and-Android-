import 'package:flutter/material.dart';

class ApiFailedWidget<C> extends StatelessWidget {
  final C controller;                 
  final String combinedErrorMessage; 
  final VoidCallback refreshOrders;   

  const ApiFailedWidget({
    super.key,
    required this.controller,
    required this.combinedErrorMessage,
    required this.refreshOrders,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
            Text(
              combinedErrorMessage,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: refreshOrders,
            child: const Text('Retry'),
          ),
          
        ],
      ),
    );
  }
}