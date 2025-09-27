import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/global/helper/toast_message/toast_message.dart';
import 'package:local/app/view/screens/features/client/user_order/controller/user_order_controller.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/order_overview_page/widgets/payment_loading_dialog.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/order_overview_page/payment_methods/product_payment/stripe_services/stripe_service.dart';

class OrderActionCard extends StatelessWidget {
  final String status;
  final dynamic orderData;
  final UserOrderController controller;
  final String orderPrice;
  final bool isCustom;

  const OrderActionCard({
    super.key,
    required this.status,
    required this.orderData,
    required this.controller,
    required this.orderPrice,
    required this.isCustom,
  });

  @override
  Widget build(BuildContext context) {
    final normalizedStatus = status.toLowerCase();

    // Return empty container if no action is needed
    if (!_shouldShowActionCard(normalizedStatus)) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        gradient: _getGradient(normalizedStatus),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: _getBorderColor(normalizedStatus), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: _getShadowColor(normalizedStatus),
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
            _buildHeader(normalizedStatus),
            const SizedBox(height: 16),
            _buildDescription(normalizedStatus),
            const SizedBox(height: 20),
            _buildActionButtons(context, normalizedStatus),
          ],
        ),
      ),
    );
  }

  bool _shouldShowActionCard(String status) {
    return status == 'offered' ||
        status == 'pending' ||
        status == 'delivery-requested';
  }

  LinearGradient _getGradient(String status) {
    switch (status) {
      case 'offered':
      case 'pending':
        return LinearGradient(
          colors: [Colors.blue[50]!, Colors.blue[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'delivery-requested':
        return LinearGradient(
          colors: [Colors.orange[50]!, Colors.orange[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return LinearGradient(
          colors: [Colors.grey[50]!, Colors.grey[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  Color _getBorderColor(String status) {
    switch (status) {
      case 'offered':
      case 'pending':
        return Colors.blue[300]!;
      case 'delivery-requested':
        return Colors.orange[300]!;
      default:
        return Colors.grey[300]!;
    }
  }

  Color _getShadowColor(String status) {
    switch (status) {
      case 'offered':
      case 'pending':
        return Colors.blue.withValues(alpha: 0.15);
      case 'delivery-requested':
        return Colors.orange.withValues(alpha: 0.15);
      default:
        return Colors.grey.withValues(alpha: 0.1);
    }
  }

  Widget _buildHeader(String status) {
    IconData iconData;
    String title;
    Color iconColor;

    switch (status) {
      case 'offered':
      case 'pending':
        iconData = Icons.local_offer_outlined;
        title = 'New Offer Received!';
        iconColor = Colors.blue[600]!;
        break;
      case 'delivery-requested':
        iconData = Icons.local_shipping_outlined;
        title = 'Delivery Confirmation';
        iconColor = Colors.orange[600]!;
        break;
      default:
        iconData = Icons.info_outline;
        title = 'Action Required';
        iconColor = Colors.grey[600]!;
    }

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(color: iconColor.withValues(alpha: 0.3), width: 2),
          ),
          child: Icon(
            iconData,
            color: iconColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: iconColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(String status) {
    String description;
    Color textColor;

    switch (status) {
      case 'offered':
      case 'pending':
        description =
            'You have received a new offer for your custom order. Please review the details and decide whether to accept or reject this offer.';
        textColor = Colors.blue[700]!;
        break;
      case 'delivery-requested':
        description =
            'The vendor has requested delivery confirmation. Please confirm if you have received your order or request a revision if needed.';
        textColor = Colors.orange[700]!;
        break;
      default:
        description = 'Please take action on this order.';
        textColor = Colors.grey[700]!;
    }

    return Text(
      description,
      style: TextStyle(
        fontSize: 14,
        color: textColor,
        height: 1.4,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, String status) {
    switch (status) {
      case 'offered':
      case 'pending':
        return _buildOfferActionButtons(context);
      case 'delivery-requested':
        return _buildDeliveryActionButtons(context);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildOfferActionButtons(BuildContext context) {
    return Obx(() => Row(
          children: [
            Expanded(
              child: _buildActionButton(
                title: 'Accept Offer',
                icon: Icons.check_circle_outline,
                color: Colors.green,
                isLoading: controller.isAcceptLoading.value,
                onTap: () => _handleAcceptOffer(context),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionButton(
                title: 'Reject Offer',
                icon: Icons.cancel_outlined,
                color: Colors.red,
                isLoading: controller.isRejectLoading.value,
                onTap: () => _handleRejectOffer(context),
              ),
            ),
          ],
        ));
  }

  Widget _buildDeliveryActionButtons(BuildContext context) {
    return Obx(() => Row(
          children: [
            Expanded(
              child: _buildActionButton(
                title: 'Accept',
                icon: Icons.check_circle_outline,
                color: Colors.green,
                isLoading: controller.isAcceptLoading.value,
                onTap: () => _handleAcceptDelivery(context),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionButton(
                title: 'Revision',
                icon: Icons.edit_note,
                color: Colors.orange,
                isLoading: controller.isRejectLoading.value,
                onTap: () => _handleRequestRevision(context),
              ),
            ),
          ],
        ));
  }

  Widget _buildActionButton({
    required String title,
    required IconData icon,
    required Color color,
    required bool isLoading,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLoading)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                else
                  Icon(
                    icon,
                    color: Colors.white,
                    size: 16,
                  ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleAcceptOffer(BuildContext context) async {
    debugPrint("Payment pressed for order acceptance, price=$orderPrice");

    // Parse and validate amount
    double? total;
    try {
      total = double.tryParse(orderPrice);
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
                sessionId: sessionId, orderId: orderData.id);
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

  Future<void> _handleRejectOffer(BuildContext context) async {
    if (await controller.rejectOrder(orderData.id)) {
      toastMessage(message: 'Offer rejected successfully');
      context.pop();
    } else {
      toastMessage(message: 'Failed to reject offer');
    }
  }

  Future<void> _handleAcceptDelivery(BuildContext context) async {
    try {
      final isOrderSuccess = await controller.acceptOrder(
          orderId: orderData.id, status: "delivery-confirmed");
      if (isOrderSuccess) {
        toastMessage(message: 'Delivery confirmed successfully!');
      } else {
        toastMessage(message: 'Failed to confirm delivery');
      }
    } catch (e) {
      debugPrint("acceptOrder error: $e");
      toastMessage(message: "Delivery confirmation failed");
    }
  }

  Future<void> _handleRequestRevision(BuildContext context) async {
    try {
      final isOrderSuccess = await controller.acceptOrder(
          orderId: orderData.id, status: "revision");
      if (isOrderSuccess) {
        toastMessage(message: 'Revision requested successfully!');
      } else {
        toastMessage(message: 'Failed to request revision');
      }
    } catch (e) {
      debugPrint("acceptOrder error: $e");
      toastMessage(message: "Revision request failed");
    }
  }
}