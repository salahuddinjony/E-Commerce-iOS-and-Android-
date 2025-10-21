import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/global/helper/toast_message/toast_message.dart';
import 'package:local/app/services/payment/controllers/order_payment_controller.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/order_overview_page/payment_methods/product_payment/payment_success_screen/payment_success_page.dart';
import 'package:local/app/view/screens/features/client/user_order/controller/user_order_controller.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/order_overview_page/widgets/payment_loading_dialog.dart';
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
      case 'delivery-confirmed':
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
      case 'delivery-confirmed':
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
      debugPrint("Error: amount too small: $total");
      toastMessage(message: "Error: amount too small");
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
      // Initialize payment controller
      final paymentController = Get.put(OrderPaymentController());

      // Initiate payment and wait for completion
      final paymentResult = await paymentController.initiateAndProcessPayment(
        context: context,
        amount: total,
        currency: 'USD',
        quantity: 1,
      );

      // Close loading dialog
      try {
        Navigator.of(context, rootNavigator: true).pop();
      } catch (_) {
        // ignore
      }

      // paymentResult can be Map (from PaymentWebViewScreen) or bool
      bool paymentCompleted = false;
      String? sessionId;
      paymentCompleted = paymentResult['success'] == true;
      sessionId = paymentResult['sessionId'] as String?;
    
      debugPrint('=== Payment Result ===');
      debugPrint('Payment completed: $paymentCompleted');
      debugPrint('Session ID: $sessionId');

      bool isOrderSuccess = false;
      String status = 'failed';

      if (paymentCompleted) {
        // ✅ Payment succeeded - now accept the order
        debugPrint('✅ Payment successful - Accepting order...');

        // Show finalizing loader while accepting the order
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          barrierColor: Colors.black45,
          builder: (ctx) => const PaymentLoadingDialog(),
        );

        try {
          isOrderSuccess = await controller.acceptOrder(
            orderId: orderData.id,
            sessionId: sessionId,
            action: 'accept_offer',
          );
        } catch (e) {
          debugPrint('acceptOrder error: $e');
          isOrderSuccess = false;
        }

        // close finalizing loader
        try {
          if (Navigator.of(context, rootNavigator: true).canPop()) {
            Navigator.of(context, rootNavigator: true).pop();
          }
        } catch (_) {}

        status = isOrderSuccess ? 'success' : 'failed';

        // Only go to PaymentSuccessPage if payment succeeded
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PaymentSuccessPage(
              isOrderSuccess: isOrderSuccess,
              amountPaid: total.toString(),
              transactionId: orderData.id,
              status: status,
            ),
          ),
        );

        if (isOrderSuccess) {
          toastMessage(message: 'Order accepted successfully!');
        } else {
          toastMessage(
            message: 'Payment succeeded but order acceptance failed',
            color: Colors.red,
          );
        }
      } else {
        debugPrint('❌ Payment was not completed - aborting order acceptance');
        toastMessage(message: 'Payment was not completed');
        // Do not navigate to PaymentSuccessPage
      }
    } catch (e, st) {
      debugPrint("Payment error: $e\n$st");
      try {
        Navigator.of(context, rootNavigator: true).pop();
      } catch (_) {}
      toastMessage(message: 'Payment failed: ${e.toString()}');
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
          status: "delivery-confirmed",
          action: 'delivery-confirmed');
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
          status: "revision",
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
