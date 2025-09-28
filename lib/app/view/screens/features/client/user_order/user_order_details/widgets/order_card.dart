import 'package:flutter/material.dart';
import 'package:local/app/view/screens/features/client/user_order/controller/user_order_controller.dart';
import 'package:local/app/view/screens/features/vendor/orders/constants/order_constants.dart';
import 'package:local/app/view/screens/features/client/user_order/user_order_details/widgets/order_card_header.dart';
import 'package:local/app/view/screens/features/client/user_order/user_order_details/widgets/order_card_description.dart';
import 'package:local/app/view/screens/features/client/user_order/user_order_details/widgets/order_card_time_info.dart';
import 'package:local/app/view/screens/features/client/user_order/user_order_details/widgets/order_card_action_buttons.dart';

class OrderCard extends StatelessWidget {
  final String status;
  final String? time;
  final String? message;
  final dynamic orderData;
  final UserOrderController? controller;
  final String? orderPrice;
  final bool isCustom;

  const OrderCard({
    super.key,
    required this.status,
    this.time,
    this.message,
    this.orderData,
    this.controller,
    this.orderPrice,
    this.isCustom = false,
  });

  @override
  Widget build(BuildContext context) {
    final normalizedStatus = status.toLowerCase();

    // Don't show card for statuses that should be completely hidden
    if (!shouldShowCard(normalizedStatus)) {
      return const SizedBox.shrink();
    }

    final hasActions = shouldShowActions(normalizedStatus);
    final colorGroup = hasActions
        ? OrderConstants.getActionCardColorGroup(normalizedStatus)
        : OrderConstants.getStatusColorGroup(normalizedStatus);

    final primaryColor =
        Color(OrderConstants.getPrimaryColorByGroup(colorGroup));
    final lightColor = Color(OrderConstants.getLightColorByGroup(colorGroup));
    final extraLightColor =
        Color(OrderConstants.getExtraLightColorByGroup(colorGroup));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [extraLightColor, lightColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: lightColor,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrderCardHeader(
              status: normalizedStatus,
              hasActions: hasActions,
              primaryColor: primaryColor,
            ),
            const SizedBox(height: 16),
            OrderCardDescription(
              status: normalizedStatus,
              hasActions: hasActions,
              primaryColor: primaryColor,
              message: message,
            ),
            if (hasActions) ...[
              const SizedBox(height: 20),
              if (controller != null)
                OrderCardActionButtons(
                  status: normalizedStatus,
                  controller: controller!,
                  orderData: orderData,
                  orderPrice: orderPrice,
                ),
            ] else ...[
              const SizedBox(height: 8),
              OrderCardTimeInfo(
                status: normalizedStatus,
                time: time,
                primaryColor: primaryColor,
              ),
            ],
          ],
        ),
      ),
    );
  }

  bool shouldShowCard(String status) {
    // Show card if it has actions OR if it's a status card that shouldn't be hidden
    return shouldShowActions(status) ||
        !OrderConstants.shouldHideStatusCard(status);
  }

  bool shouldShowActions(String status) {
    // Show actions for custom orders with actionable statuses
    return isCustom && OrderConstants.shouldShowActionCard(status);
  }
}
