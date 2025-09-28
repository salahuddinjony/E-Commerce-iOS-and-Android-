import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/global/helper/toast_message/toast_message.dart';
import 'package:local/app/view/screens/features/client/user_order/controller/user_order_controller.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/order_overview_page/widgets/payment_loading_dialog.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/order_overview_page/payment_methods/product_payment/stripe_services/stripe_service.dart';
import 'package:local/app/view/screens/features/vendor/orders/constants/order_constants.dart';
import 'package:local/app/view/screens/features/client/user_order/user_order_details/widgets/order_action_button.dart';

class OrderCardActionButtons extends StatelessWidget {
  final String status;
  final UserOrderController controller;
  final dynamic orderData;
  final String? orderPrice;

  const OrderCardActionButtons({
    super.key,
    required this.status,
    required this.controller,
    required this.orderData,
    this.orderPrice,
  });

  @override
  Widget build(BuildContext context) {
    final buttonConfigs = OrderConstants.getActionCardButtons(status);

    if (buttonConfigs.isEmpty) {
      return const SizedBox.shrink();
    }

    return Obx(() => Row(
          children: buttonConfigs
              .asMap()
              .entries
              .map((entry) {
                final index = entry.key;
                final config = entry.value;

                return [
                  if (index > 0) const SizedBox(width: 16),
                  Expanded(
                    child: OrderActionButton(
                      title: config['title'],
                      icon: config['icon'],
                      color:
                          OrderConstants.getColorByGroup(config['colorGroup']),
                      isLoading: getLoadingState(config['action']),
                      onTap: () => handleAction(context, config['action']),
                    ),
                  ),
                ];
              })
              .expand((widgets) => widgets)
              .toList(),
        ));
  }

  bool getLoadingState(String action) {
    switch (action) {
      case 'accept_offer':
        return controller.isAcceptOfferLoading.value;
      case 'reject_offer':
        return controller.isRejectOfferLoading.value;
      case 'accept_delivery':
        return controller.isAcceptDeliveryLoading.value;
      case 'request_revision':
        return controller.isRequestRevisionLoading.value;
      default:
        return false;
    }
  }

  void handleAction(BuildContext context, String action) {
    switch (action) {
      case 'accept_offer':
        handleAcceptOffer(context);
        break;
      case 'reject_offer':
        handleRejectOffer(context);
        break;
      case 'accept_delivery':
        handleAcceptDelivery(context);
        break;
      case 'request_revision':
        handleRequestRevision(context);
        break;
    }
  }

  Future<void> handleAcceptOffer(BuildContext context) async {
    if (orderPrice == null) {
      toastMessage(message: "Error: Invalid order price");
      return;
    }

    debugPrint("Payment pressed for order acceptance, price=$orderPrice");

    // Parse and validate amount
    double? total;
    try {
      total = double.tryParse(orderPrice!);
    } catch (e) {
      debugPrint("Error parsing order price: $e");
    }

    if (total == null) {
      debugPrint("Error: orderPrice is null or invalid");
      toastMessage(message: "Error: Invalid order price");
      return;
    }
    if (total < 0.01) {
      debugPrint("Error: amount too small for Stripe: $total");
      toastMessage(message: "Error: amount too small for Stripe");
      return;
    }

    // Show loading dialog
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black45,
      builder: (_) => const PaymentLoadingDialog(),
    );

    try {
      bool paymentSuccessful = false;
      final paymentFuture = StripeServicePayment.instance.makePayment(
        context: context,
        amount: total.toInt(),
        currency: 'usd',
        onPaymentSheetOpened: () {
          try {
            Navigator.of(context, rootNavigator: true).pop();
          } catch (_) {
            // ignore
          }
        },
        onPaymentSuccess: (sessionId, detailedPI) async {
          try {
            final isOrderSuccess = await controller.acceptOrder(
                sessionId: sessionId,
                orderId: orderData.id,
                action: 'accept_offer');
            if (isOrderSuccess) {
              paymentSuccessful = true;
              toastMessage(message: 'Order accepted successfully!');
            } else {
              toastMessage(
                  message: 'Payment succeeded but order acceptance failed');
            }
            return isOrderSuccess;
          } catch (e) {
            debugPrint("acceptOrder error: $e");
            toastMessage(message: "Order post-payment failed");
            return false;
          }
        },
      );

      await paymentFuture;
      debugPrint("makePayment completed");

      if (paymentSuccessful) {
        context.pop();
      }
    } catch (e, st) {
      debugPrint("makePayment error: $e\n$st");
    }
  }

  Future<void> handleRejectOffer(BuildContext context) async {
    if (await controller.rejectOrder(
        orderId: orderData.id, status: "rejected", action: 'reject_offer')) {
      controller.fetchCustomOrders();
      context.pop();
      toastMessage(message: 'Offer rejected successfully');
    } else {
      toastMessage(message: 'Failed to reject offer', color: Colors.red);
    }
  }

  Future<void> handleAcceptDelivery(BuildContext context) async {
    try {
      final isOrderSuccess = await controller.acceptOrder(
          orderId: orderData.id,
          status: "delivery-confirmeds",
          action: 'accept_delivery');
      if (isOrderSuccess) {
        controller.fetchCustomOrders();
        context.pop();
        toastMessage(message: 'Delivery confirmed successfully!');
      } else {
        toastMessage(message: 'Failed to confirm delivery', color: Colors.red);
      }
    } catch (e) {
      debugPrint("acceptOrder error: $e");
      toastMessage(message: "Delivery confirmation failed");
    }
  }

  Future<void> handleRequestRevision(BuildContext context) async {
    try {
      final isOrderSuccess = await controller.acceptOrder(
          orderId: orderData.id,
          status: "revisions",
          action: 'request_revision');
      if (isOrderSuccess) {
        controller.fetchCustomOrders();
        context.pop();
        toastMessage(message: 'Revision requested successfully!');
      } else {
        toastMessage(message: 'Failed to request revision', color: Colors.red);
      }
    } catch (e) {
      debugPrint("acceptOrder error: $e");
      toastMessage(message: "Revision request failed", color: Colors.red);
    }
  }
}
