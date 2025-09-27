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
      // Step 1: Create a real Stripe Checkout Session
      final checkoutSession = await _createCheckoutSession(amount, currency);
      
      if (checkoutSession == null) {
        debugPrint("Failed to create Checkout Session");
        Get.snackbar('Payment Failed', 'Could not create checkout session.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white);
        return;
      }

      final String? sessionId = checkoutSession['id'] as String?;
      debugPrint("Created Checkout Session: $sessionId");

      if (sessionId == null) {
        debugPrint("Session ID missing from checkout session");
        Get.snackbar('Payment Failed', 'Missing session ID.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white);
        return;
      }

      // Step 2: Create a separate PaymentIntent for the payment sheet
      final paymentIntent = await _createPaymentIntentForSession(
        amount,
        currency,
        sessionId,
      );

      if (paymentIntent == null) {
        debugPrint("Failed to create PaymentIntent for session");
        Get.snackbar('Payment Failed', 'Could not create payment intent.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white);
        return;
      }

      final String? paymentIntentClientSecret =
          paymentIntent['client_secret'] as String?;
      final String? paymentIntentId = paymentIntent['id'] as String?;

      debugPrint("Created PaymentIntent: $paymentIntentId for session: $sessionId");

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
        debugPrint("Session ID: $sessionId");
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
        if (detailedPI != null) {
          status = detailedPI['status']?.toString();

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
          }
        }

        debugPrint("Using session ID for backend: $sessionId");

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
            // pass the actual checkout session ID and detailedPI
            orderSucceeded = await onPaymentSuccess(sessionId, detailedPI);
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
              sessionId: sessionId, // This is now the actual checkout session ID
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

  Future<Map<String, dynamic>?> _createCheckoutSession(
      int amount, String currency) async {
    try {
      final Dio dio = Dio();

      Map<String, dynamic> data = {
        "mode": "payment",
        "line_items": [
          {
            "price_data": {
              "currency": currency,
              "product_data": {
                "name": "Order Payment",
              },
              "unit_amount": _calculateAmount(amount),
            },
            "quantity": 1,
          }
        ],
        "success_url": "https://success.com",
        "cancel_url": "https://cancel.com",
      };

      final response = await dio.post(
        "https://api.stripe.com/v1/checkout/sessions",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer ${Constantstripe.stripeSecretKey}",
          },
        ),
      );

      if (response.data != null && response.data is Map<String, dynamic>) {
        debugPrint("Checkout Session created: ${response.data['id']}");
        return Map<String, dynamic>.from(response.data as Map);
      } else {
        debugPrint(
            "Failed to create Checkout Session: ${response.statusCode} - ${response.statusMessage}");
        return null;
      }
    } catch (e) {
      debugPrint("Error in _createCheckoutSession: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> _createPaymentIntentForSession(
      int amount, String currency, String sessionId) async {
    try {
      final Dio dio = Dio();

      Map<String, dynamic> data = {
        "amount": _calculateAmount(amount),
        "currency": currency,
        "metadata": {
          "checkout_session_id": sessionId,
          "payment_type": "order_payment",
        },
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
        debugPrint("PaymentIntent created: ${response.data['id']}");
        debugPrint("Client secret: ${response.data['client_secret']}");
        debugPrint("Linked to session: $sessionId");

        return Map<String, dynamic>.from(response.data as Map);
      } else {
        debugPrint(
            "Failed to create PaymentIntent: ${response.statusCode} - ${response.statusMessage}");
        return null;
      }
    } catch (e) {
      debugPrint("Error in _createPaymentIntentForSession: $e");
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
