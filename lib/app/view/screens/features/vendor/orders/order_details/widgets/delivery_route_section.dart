import 'package:flutter/material.dart';
import '../../models/custom_order_response_model.dart';
import '../../models/general_order_response_model.dart';
import 'reusable_rows.dart';

class DeliveryRouteSection extends StatelessWidget {
  final bool isCustomOrder;
  final dynamic orderData;

  const DeliveryRouteSection({
    super.key,
    required this.isCustomOrder,
    required this.orderData,
  });

  @override
  Widget build(BuildContext context) {
    if (isCustomOrder) {
      final order = orderData as Order;
      return Column(
        children: [
          DeliveryRouteItem(
            iconData: Icons.store,
            label: 'Vendor',
            value: 'U Tee Hub Store',
          ),
          DeliveryRouteItem(
            iconData: Icons.location_on_outlined,
            label: 'Drop-off',
            value: order.shippingAddress,
          ),
        ],
      );
    } else {
      final order = orderData as GeneralOrder;
      return Column(
        children: [
          DeliveryRouteItem(
            iconData: Icons.store,
            label: 'Vendor',
            value: order.vendor?.profile.id.name ?? 'Unknown Vendor',
          ),
          DeliveryRouteItem(
            iconData: Icons.location_on_outlined,
            label: 'Drop-off',
            value: order.shippingAddress.isNotEmpty ? order.shippingAddress : 'Unknown Location',
          ),
        ],
      );
    }
  }
}