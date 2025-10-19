import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:local/app/data/local/shared_prefs.dart';
import 'package:local/app/services/api_client.dart';
import 'package:local/app/services/api_url.dart';
import 'package:local/app/services/payment/models/initiate_payment_request.dart';
import 'package:local/app/services/payment/models/initiate_payment_response.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentService {
  /// Initiates payment by calling the /order/initiate-payment API
  /// Returns the payment URL if successful
  static Future<InitiatePaymentResponse?> initiatePayment({
    required double amount,
    required String currency,
    required int quantity,
  }) async {
    try {
      // Get customer email from shared preferences
      final customerEmail = await SharePrefsHelper.getString(AppConstants.userEmail);
      
      if (customerEmail.isEmpty) {
        debugPrint('Error: Customer email not found in shared preferences');
        return null;
      }

      // Create request body
      final request = InitiatePaymentRequest(
        customerEmail: customerEmail,
        amount: amount,
        currency: currency,
        quantity: quantity,
      );

      debugPrint('Initiating payment with request: ${jsonEncode(request.toJson())}');

      // Make API call
      final response = await ApiClient.postData(
        ApiUrl.paymentCheck,
        jsonEncode(request.toJson()),
      );

      debugPrint('Payment initiation response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final paymentResponse = InitiatePaymentResponse.fromJson(response.body);
        debugPrint('Payment URL: ${paymentResponse.data?.url}');
        return paymentResponse;
      } else {
        debugPrint('Payment initiation failed: ${response.statusText}');
        return null;
      }
    } catch (e, stackTrace) {
      debugPrint('Error initiating payment: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
  }

  /// Opens the payment URL in an external browser or in-app browser
  static Future<bool> openPaymentUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      
      // Try to launch in external browser
      if (await canLaunchUrl(uri)) {
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        return launched;
      } else {
        debugPrint('Could not launch URL: $url');
        return false;
      }
    } catch (e) {
      debugPrint('Error opening payment URL: $e');
      return false;
    }
  }

  /// Opens the payment URL in an in-app browser (webview)
  static Future<bool> openPaymentUrlInApp(String url) async {
    try {
      final uri = Uri.parse(url);
      
      // Try to launch in in-app webview
      if (await canLaunchUrl(uri)) {
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.inAppWebView,
          webViewConfiguration: const WebViewConfiguration(
            enableJavaScript: true,
            enableDomStorage: true,
          ),
        );
        return launched;
      } else {
        debugPrint('Could not launch URL: $url');
        return false;
      }
    } catch (e) {
      debugPrint('Error opening payment URL in app: $e');
      return false;
    }
  }
}
