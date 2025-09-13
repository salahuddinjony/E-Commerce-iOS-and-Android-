import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/product_details/controller/product_details_controller.dart';
import 'widgets/payment_result_card.dart';

class PaymentSuccessPage extends StatelessWidget {
  final bool isOrderSuccess;
  final String? transactionId;
  final String? status;
  final String? amountPaid;
  final Map<String, dynamic>? details;
  
  // added optional fields used by stripe_service
  final String? chargeId;
  final String? paymentMethod;
  final String? sessionId;

  const PaymentSuccessPage({
    super.key,
    this.transactionId,
    this.status,
    this.amountPaid,
    this.details,
    this.chargeId,
    this.paymentMethod,
    this.sessionId,
    required this.isOrderSuccess,
  });

  void _showContactDialog(BuildContext context) {
    const supportEmail = 'support@uteehub.com';
    const supportPhone = '+8801712XXXXXX';

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: Center(child: const Text('Contact Support', style: TextStyle(fontWeight: FontWeight.bold),)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                'If your payment succeeded but order creation failed, please contact support.'),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.email_outlined, size: 18),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(supportEmail,
                        style: const TextStyle(fontWeight: FontWeight.w500))),
                IconButton(
                  icon: const Icon(Icons.copy, size: 18),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Email copied to clipboard')));
                  },
                )
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.phone_outlined, size: 18),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(supportPhone,
                        style: const TextStyle(fontWeight: FontWeight.w500))),
                IconButton(
                  icon: const Icon(Icons.copy, size: 18),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Phone copied to clipboard')));
                  },
                )
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handleDone(BuildContext context) {
    final controller = Get.isRegistered<ProductDetailsController>()
        ? Get.find<ProductDetailsController>()
        : null;
    controller?.clearSelections();
    if (Get.isRegistered<ProductDetailsController>()) {
      Get.delete<ProductDetailsController>(force: true);
    }
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: SingleChildScrollView(
              child: PaymentResultCard(
                isOrderSuccess: isOrderSuccess,
                transactionId: transactionId,
                status: status,
                amountPaid: amountPaid,
                details: details,
                // forward new fields to the reusable card (if your card supports them)
                chargeId: chargeId,
                paymentMethod: paymentMethod,
                sessionId: sessionId,
                onDone: () => _handleDone(context),
                onContact: () => _showContactDialog(context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
