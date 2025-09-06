import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/view/screens/features/vendor/orders/controller/order_controller.dart';
import '../../models/custom_order_response_model.dart';
import '../../models/general_order_response_model.dart';
import '../widgets/order_header.dart';
import '../widgets/order_details_section.dart';
import '../widgets/date_price_row.dart';
import '../widgets/delivery_route_section.dart';
import '../widgets/action_buttons.dart';

class OrderDetailsScreen extends StatelessWidget {
  final dynamic orderData; // CustomOrder or GeneralOrder
  final bool isCustomOrder;
  final OrdersController controller;

  const OrderDetailsScreen({
    super.key,
    required this.orderData,
    required this.isCustomOrder,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text('${isCustomOrder ? 'Custom' : 'General'} Order Details'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrderHeader(
              isCustomOrder: isCustomOrder,
              orderData: orderData,
            ),
            const SizedBox(height: 24),
            const Text(
              'Order Details',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            OrderDetailsSection(
              isCustomOrder: isCustomOrder,
              orderData: orderData,
            ),
            const SizedBox(height: 20),
            DatePriceRow(
              date: extractCreatedDate(),
              price: extractPrice(),
            ),
            const SizedBox(height: 24),
            const Text(
              'Delivery Route',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            DeliveryRouteSection(
              isCustomOrder: isCustomOrder,
              orderData: orderData,
            ),
            SizedBox(height: 50.h),
            ActionButtons(
              isCustomOrder: isCustomOrder,
              orderData: orderData,
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }

  String extractCreatedDate() {
    if (isCustomOrder) {
      final order = orderData as Order;
      return '${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}';
    } else {
      final order = orderData as GeneralOrder;
      return '${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}';
    }
  }

  String extractPrice() {
    if (isCustomOrder) {
      final order = orderData as Order;
      return '${order.currency} ${order.price}';
    } else {
      final order = orderData as GeneralOrder;
      return '${order.currency} ${order.price}';
    }
  }
}
