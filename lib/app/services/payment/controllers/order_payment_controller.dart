import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local/app/global/helper/toast_message/toast_message.dart';
import 'package:local/app/services/payment/payment_service.dart';
import 'package:local/app/services/payment/screens/payment_webview_screen.dart';

class OrderPaymentController extends GetxController {
  final RxBool isInitiatingPayment = false.obs;
  
  /// Initiates payment and opens the payment URL
  /// Returns a map with 'success' (bool) and 'sessionId' (String?) if payment was completed successfully
  /// Requires BuildContext for navigation
  Future<Map<String, dynamic>> initiateAndProcessPayment({
    required BuildContext context,
    required double amount,
    required String currency,
    required int quantity,
  }) async {
    try {
      isInitiatingPayment.value = true;

      // Initiate payment
      final paymentResponse = await PaymentService.initiatePayment(
        amount: amount,
        currency: currency,
        quantity: quantity,
      );

      isInitiatingPayment.value = false;

      if (paymentResponse == null) {
        toastMessage(message: 'Failed to initiate payment');
        return {'success': false, 'sessionId': null};
      }

      if (paymentResponse.data?.url == null || paymentResponse.data!.url.isEmpty) {
        toastMessage(message: 'Payment URL not received');
        return {'success': false, 'sessionId': null};
      }

      // Navigate to payment webview screen using Navigator
      final paymentResult = await Navigator.of(context).push<dynamic>(
        MaterialPageRoute(
          builder: (context) => PaymentWebViewScreen(
            paymentUrl: paymentResponse.data!.url,
          ),
        ),
      );

      // Handle different return types
      if (paymentResult is Map<String, dynamic>) {
        return paymentResult;
      } else if (paymentResult is bool) {
        return {'success': paymentResult, 'sessionId': null};
      }

      return {'success': false, 'sessionId': null};
    } catch (e) {
      debugPrint('Error in initiateAndProcessPayment: $e');
      toastMessage(message: 'Payment error: ${e.toString()}');
      return {'success': false, 'sessionId': null};
    } finally {
      isInitiatingPayment.value = false;
    }
  }

  @override
  void onClose() {
    isInitiatingPayment.close();
    super.onClose();
  }
}
