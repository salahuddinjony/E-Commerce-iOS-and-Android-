import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/global/helper/toast_message/toast_message.dart';

class PaymentWebViewScreen extends StatelessWidget {
  final String paymentUrl;
  final Function(bool success)? onPaymentComplete;

  const PaymentWebViewScreen({
    super.key,
    required this.paymentUrl,
    this.onPaymentComplete,
  });

  @override
  Widget build(BuildContext context) {
    return _PaymentWebViewContent(
      paymentUrl: paymentUrl,
      onPaymentComplete: onPaymentComplete,
    );
  }
}

class _PaymentWebViewContent extends StatefulWidget {
  final String paymentUrl;
  final Function(bool success)? onPaymentComplete;

  const _PaymentWebViewContent({
    required this.paymentUrl,
    this.onPaymentComplete,
  });

  @override
  State<_PaymentWebViewContent> createState() => _PaymentWebViewContentState();
}

class _PaymentWebViewContentState extends State<_PaymentWebViewContent> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _paymentCompleted = false;
  int _loadingProgress = 0;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _loadingProgress = progress;
              if (progress == 100) {
                _isLoading = false;
              }
            });
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
            debugPrint('Page finished loading: $url');
            
            // Check if payment was successful
            _checkPaymentStatus(url);
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView error: ${error.description}');
            if (error.errorType == WebResourceErrorType.hostLookup ||
                error.errorType == WebResourceErrorType.connect ||
                error.errorType == WebResourceErrorType.timeout) {
              toastMessage(message: 'Network error. Please check your connection.');
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            debugPrint('Navigation to: ${request.url}');
            
            // Check for success/cancel URLs
            if (_isPaymentSuccessUrl(request.url)) {
              _handlePaymentSuccess(request.url);
              return NavigationDecision.prevent;
            } else if (_isPaymentCancelUrl(request.url)) {
              _handlePaymentCancel();
              return NavigationDecision.prevent;
            }
            
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  bool _isPaymentSuccessUrl(String url) {
    // Stripe success URLs typically contain 'success' or redirect to success page
    return url.contains('/success') || 
           url.contains('session_id=') ||
           url.contains('payment_intent_client_secret') && url.contains('payment_status=succeeded') ||
           url.contains('setup_intent_client_secret');
  }

  String? _extractSessionId(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.queryParameters['session_id'];
    } catch (e) {
      debugPrint('Error extracting session_id: $e');
      return null;
    }
  }

  bool _isPaymentCancelUrl(String url) {
    // Check for cancel or failure URLs
    return url.contains('/cancel') || 
           url.contains('payment_status=canceled') ||
           url.contains('payment_status=failed');
  }

  void _checkPaymentStatus(String url) {
    // Additional check when page finishes loading
    if (_isPaymentSuccessUrl(url) && !_paymentCompleted) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && !_paymentCompleted) {
          _handlePaymentSuccess(url);
        }
      });
    }
  }

  void _handlePaymentSuccess([String? url]) {
    if (_paymentCompleted) return;
    
    setState(() {
      _paymentCompleted = true;
    });
    
    // Extract session_id from URL if available
    String? sessionId;
    if (url != null) {
      sessionId = _extractSessionId(url);
      debugPrint('Extracted session_id: $sessionId');
    }
    
    toastMessage(message: 'Payment completed successfully!');
    widget.onPaymentComplete?.call(true);
    
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        // Return session_id with the success result
        Navigator.of(context).pop({'success': true, 'sessionId': sessionId});
      }
    });
  }

  void _handlePaymentCancel() {
    if (_paymentCompleted) return;
    
    toastMessage(message: 'Payment was cancelled');
    widget.onPaymentComplete?.call(false);
    
    if (mounted) {
      Navigator.of(context).pop(false);
    }
  }

  Future<bool> _onWillPop() async {
    if (_paymentCompleted) return true;
    
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.brightCyan, size: 28),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Cancel Payment?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkNaturalGray,
                ),
              ),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to cancel the payment? Your order will not be processed.',
          style: TextStyle(
            fontSize: 15,
            color: AppColors.naturalGray,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Continue Payment',
              style: TextStyle(
                color: AppColors.brightCyan,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Cancel Payment'),
          ),
        ],
      ),
    );
    
    return shouldExit ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.brightCyan,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text(
            'Complete Payment',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          bottom: _isLoading
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(3),
                  child: LinearProgressIndicator(
                    value: _loadingProgress / 100,
                    backgroundColor: AppColors.white.withValues(alpha: 0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.white),
                  ),
                )
              : null,
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading)
              Container(
                color: AppColors.white,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.brightCyan),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Loading payment page...',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.naturalGray,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Please wait',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.naturalGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
