import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:local/app/global/helper/toast_message/toast_message.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/order_overview_page/widgets/payment_loading_dialog.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/order_overview_page/payment_methods/product_payment/stripe_services/constant_stripe.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/order_overview_page/payment_methods/product_payment/payment_success_screen/payment_success_page.dart';
import 'package:get/get.dart';

class StripeServicePayment {
  StripeServicePayment._privateConstructor();
  static final StripeServicePayment instance =
      StripeServicePayment._privateConstructor();

  /// Call this in main() before runApp to initialize Stripe
  static Future<void> setup() async {
    WidgetsFlutterBinding.ensureInitialized();
    Stripe.publishableKey = Constantstripe.stripePublishableKey;
  }

  /// Call this to start the payment flow
  // Updated signature: added BuildContext to show dialogs, optional callback that will be called when the native/payment sheet is shown
  Future<void> makePayment({
    required BuildContext context,
    required int amount,
    required String currency,
    VoidCallback? onPaymentSheetOpened,
    // CHANGED: callback should return a bool indicating if order creation succeeded
    Future<bool> Function(String? sessionId, Map<String, dynamic>? detailedPI)? onPaymentSuccess,
  }) async {
    try {
      final paymentIntent = await _createPaymentIntent(
        amount,
        currency,
      );

      if (paymentIntent == null) {
        debugPrint("Failed to create PaymentIntent");
        Get.snackbar('Payment Failed', 'Could not create payment intent.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white);
        return;
      }

      final String? paymentIntentClientSecret =
          paymentIntent['client_secret'] as String?;
      final String? paymentIntentId = paymentIntent['id'] as String?;

      if (paymentIntentClientSecret == null) {
        debugPrint("Client secret missing on PaymentIntent");
        Get.snackbar('Payment Failed', 'Missing client secret.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white);
        return;
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: "U Tee Hub",
        ),
      );

      try {
        if (onPaymentSheetOpened != null) {
          onPaymentSheetOpened();
        }
      } catch (_) {
        // Ignore any errors from the callback to avoid disrupting the payment flow.
      }

      await _processPayment();

      // Show a non-dismissible loader while we fetch final details and navigate
      bool loaderShown = false;
      try {
        loaderShown = true;
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) {
            return PopScope(
                canPop: false,
                child: const PaymentLoadingDialog(
                  message: 'Finalizing payment…',
                  title: 'Please do not close the app.',
                ));
          },
        );

        // If presentPaymentSheet completes without throwing, consider it a success
        debugPrint("Payment successful. paymentIntentId: $paymentIntentId");
        debugPrint(
            "Client secret (partial): ${paymentIntentClientSecret.length > 12 ? paymentIntentClientSecret.substring(0, 12) + '...' : paymentIntentClientSecret}");

        // Retrieve fresh, expanded details from Stripe (charges, payment method details, balance transaction, etc.)
        Map<String, dynamic>? detailedPI;
        try {
          if (paymentIntentId != null) {
            detailedPI = await _retrievePaymentIntent(paymentIntentId);
          }
        } catch (e) {
          debugPrint("Error retrieving detailed PaymentIntent: $e");
        }

        // Mask client_secret before printing
        Map<String, dynamic>? maskSensitive(Map<String, dynamic>? m) {
          if (m == null) return null;
          final copy = Map<String, dynamic>.from(m);
          if (copy.containsKey('client_secret') &&
              copy['client_secret'] is String) {
            final s = copy['client_secret'] as String;
            copy['client_secret'] = _maskSecret(s);
          }
          return copy;
        }

        final pretty = JsonEncoder.withIndent('  ').convert(
            maskSensitive(detailedPI) ?? maskSensitive(paymentIntent) ?? {});
        debugPrint("Full Payment details:\n$pretty");

        // extract charge id or other common fields for quick display
        String? chargeId;
        String? status;
        String? paymentMethod;
        String? sessionId;
        if (detailedPI != null) {
          status = detailedPI['status']?.toString();
          // try common places for a session id (metadata or checkout_session)
          sessionId = detailedPI['metadata'] is Map
              ? (detailedPI['metadata']['session_id'] as String?) ??
                  (detailedPI['metadata']['checkout_session'] as String?)
              : null;
          if (sessionId == null && detailedPI.containsKey('checkout_session')) {
            sessionId = detailedPI['checkout_session']?.toString();
          }

          final charges = (detailedPI['charges']?['data'] as List<dynamic>?);
          if (charges != null && charges.isNotEmpty) {
            final firstCharge = charges.first as Map<String, dynamic>;
            chargeId = firstCharge['id'] as String?;
            paymentMethod =
                (firstCharge['payment_method_details']?['type'] as String?) ??
                    (detailedPI['payment_method_types'] is List
                        ? (detailedPI['payment_method_types'] as List)
                            .first
                            .toString()
                        : null);

            // sometimes session id can be attached to a charge metadata
            if (sessionId == null && firstCharge['metadata'] is Map) {
              sessionId = (firstCharge['metadata']['session_id'] as String?) ??
                  (firstCharge['metadata']['checkout_session'] as String?);
            }
          }
        }

        // fallback: look for session id in original PaymentIntent payload (metadata or top-level)
        if (sessionId == null) {
          sessionId = (paymentIntent['metadata'] is Map)
              ? (paymentIntent['metadata']['session_id'] as String?) ??
                  (paymentIntent['metadata']['checkout_session'] as String?)
              : null;
          if (sessionId == null &&
              paymentIntent.containsKey('checkout_session')) {
            sessionId = paymentIntent['checkout_session']?.toString();
          }
        }

        debugPrint("Session id (if any): $sessionId");

        // Determine final payment status (prefer detailedPI)
        final String? finalStatus =
            status ?? (paymentIntent['status'] as String?);

        if (finalStatus == null || finalStatus.toLowerCase() != 'succeeded') {
          toastMessage(
              message: "Payment Failed, Try Again!", color: Colors.redAccent);
          debugPrint("Payment not succeeded. Status: $finalStatus");
          return;
        }

        // NEW: call the onPaymentSuccess callback and capture whether order creation succeeded
        bool orderSucceeded = onPaymentSuccess == null;
        if (onPaymentSuccess != null) {
          try {
            // pass sessionId (if any) and detailedPI (if any) , use as sessionId ===> paymentIntentId
            orderSucceeded = await onPaymentSuccess(paymentIntentId, detailedPI);
          } catch (e) {
            debugPrint("onPaymentSuccess callback error: $e");
            orderSucceeded = false;
          }
        }

        // navigate to success page (pass masked details and summary)
        try {
          // close any loader/dialog presented earlier (use rootNavigator)
          try {
            if (Navigator.of(context, rootNavigator: true).canPop()) {
              Navigator.of(context, rootNavigator: true).pop();
            }
          } catch (_) {}
          try {
            if (loaderShown &&
                Navigator.of(context, rootNavigator: true).canPop()) {
              Navigator.of(context, rootNavigator: true).pop();
            }
          } catch (_) {}

          final maskedDetails =
              maskSensitive(detailedPI) ?? maskSensitive(paymentIntent);
          final amountPaidFormatted = (amount.toDouble()).toStringAsFixed(2);
          debugPrint(
              "Navigating to success page with amount paid: \$$amountPaidFormatted");

          final route = MaterialPageRoute(
            builder: (ctx) => PaymentSuccessPage(
              // USE actual order result here
              isOrderSuccess: orderSucceeded,
              transactionId: paymentIntentId,
              chargeId: chargeId,
              status: finalStatus,
              paymentMethod: paymentMethod,
              sessionId: sessionId,
              amountPaid: '\$$amountPaidFormatted',
              details: maskedDetails,
            ),
          );

          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            route,
            (Route<dynamic> r) {
              return r.isFirst;
            },
          );
        } catch (e) {
          debugPrint("Error navigating to success page: $e");
          Get.snackbar('Navigation Error', 'Failed to show success page.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.redAccent,
              colorText: Colors.white);
        }
      } finally {
        // Ensure loader removed in all cases
        if (loaderShown) {
          try {
            if (Navigator.of(context, rootNavigator: true).canPop()) {
              Navigator.of(context, rootNavigator: true).pop();
            }
          } catch (_) {}
        }
      }
    } catch (e) {
      debugPrint("Error in makePayment: $e");
      Get.snackbar('Payment Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          duration: const Duration(seconds: 4));
    }
  }

  Future<Map<String, dynamic>?> _createPaymentIntent(
      int amount, String currency) async {
    try {
      final Dio dio = Dio();

      Map<String, dynamic> data = {
        "amount": _calculateAmount(amount),
        "currency": currency,
      };

      final response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer ${Constantstripe.stripeSecretKey}",
          },
        ),
      );

      if (response.data != null && response.data is Map<String, dynamic>) {
        debugPrint("PaymentIntent created: ${response.data}");
        debugPrint("Client secret: ${response.data['client_secret']}");

        return Map<String, dynamic>.from(response.data as Map);
      } else {
        debugPrint(
            "Failed to create PaymentIntent: ${response.statusCode} - ${response.statusMessage}");
        return null;
      }
    } catch (e) {
      debugPrint("Error in _createPaymentIntent: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> _retrievePaymentIntent(String id) async {
    try {
      final Dio dio = Dio();
      // expand common related objects so we can log richer info
      final response = await dio.get(
        "https://api.stripe.com/v1/payment_intents/$id",
        queryParameters: {
          "expand[]": [
            "charges.data.payment_method_details",
            "charges.data.balance_transaction",
          ],
        },
        options: Options(
          headers: {
            "Authorization": "Bearer ${Constantstripe.stripeSecretKey}",
          },
        ),
      );

      if (response.data != null && response.data is Map<String, dynamic>) {
        return Map<String, dynamic>.from(response.data as Map);
      }
      return null;
    } catch (e) {
      debugPrint("Error retrieving PaymentIntent from Stripe: $e");
      return null;
    }
  }

  Future<void> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      // print("Error in _processPayment: $e");
      rethrow;
    }
  }

  String _calculateAmount(int amount) {
    // Stripe expects amount in cents
    return (amount * 100).toString();
  }

  static String _maskSecret(String s) {
    if (s.length <= 8) return '****';
    return s.substring(0, 4) + '...' + s.substring(s.length - 4);
  }

  /// Masks sensitive fields in the payment intent map for logging or display.
  static Map<String, dynamic>? maskSensitive(
      Map<String, dynamic>? paymentIntent) {
    if (paymentIntent == null) return null;
    final masked = Map<String, dynamic>.from(paymentIntent);
    if (masked.containsKey('client_secret') &&
        masked['client_secret'] is String) {
      masked['client_secret'] = _maskSecret(masked['client_secret']);
    }
    if (masked.containsKey('id') && masked['id'] is String) {
      masked['id'] = _maskSecret(masked['id']);
    }
    return masked;
  }
}
