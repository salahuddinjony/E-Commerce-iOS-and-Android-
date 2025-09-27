import 'package:flutter/material.dart';
import 'package:local/app/view/screens/features/client/user_order/user_order_details/widgets/order_status_card.dart';

// Demo widget to showcase all different card states
class OrderCardShowcase extends StatelessWidget {
  const OrderCardShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Cards Showcase'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Action Cards (Interactive)',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            
            // Action card for offered status
            _buildDemoActionCard('offered'),
            const SizedBox(height: 16),
            
            // Action card for delivery-requested status
            _buildDemoActionCard('delivery-requested'),
            const SizedBox(height: 32),
            
            const Text(
              'Status Cards (Informational)',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            
            // Status cards for different states
            const OrderStatusCard(
              status: 'accepted',
              time: '2023-12-01T10:30:00Z',
            ),
            const SizedBox(height: 16),
            
            const OrderStatusCard(
              status: 'in-progress',
              time: '2023-12-02T14:15:00Z',
            ),
            const SizedBox(height: 16),
            
            const OrderStatusCard(
              status: 'completed',
              time: '2023-12-05T16:45:00Z',
            ),
            const SizedBox(height: 16),
            
            const OrderStatusCard(
              status: 'delivered',
              time: '2023-12-06T09:20:00Z',
            ),
            const SizedBox(height: 16),
            
            const OrderStatusCard(
              status: 'delivery-confirmed',
              time: '2023-12-06T12:30:00Z',
            ),
            const SizedBox(height: 16),
            
            const OrderStatusCard(
              status: 'cancelled',
              time: '2023-12-02T11:10:00Z',
            ),
            const SizedBox(height: 16),
            
            const OrderStatusCard(
              status: 'rejected',
              time: '2023-12-01T15:30:00Z',
            ),
            const SizedBox(height: 16),
            
            const OrderStatusCard(
              status: 'revision',
              time: '2023-12-03T13:25:00Z',
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoActionCard(String status) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Status: ${status.toUpperCase()}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          // Note: In a real app, you would pass actual controller and orderData
          // This is just for showcase purposes
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Interactive ${status == 'offered' ? 'Accept/Reject' : 'Delivery/Revision'} buttons would appear here',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}