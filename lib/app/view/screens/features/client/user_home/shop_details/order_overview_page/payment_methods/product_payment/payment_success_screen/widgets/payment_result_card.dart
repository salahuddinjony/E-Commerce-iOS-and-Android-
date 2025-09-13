import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/global/helper/toast_message/toast_message.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';

class PaymentResultCard extends StatelessWidget {
  final bool isOrderSuccess;
  final String? transactionId;
  final String? status;
  final String? paymentMethod;
  final String? sessionId;
  final String? amountPaid;
  final String? chargeId;
  final Map<String, dynamic>? details;

  // Callbacks to keep this widget reusable
  final VoidCallback onDone;
  final VoidCallback onContact;

  const PaymentResultCard({
    super.key,
    required this.isOrderSuccess,
    this.transactionId,
    this.status,
    this.paymentMethod,
    this.sessionId,
    this.amountPaid,
    this.details,
    required this.onDone,
    required this.onContact,
    this.chargeId,
  });

  Widget _infoRow(BuildContext context, String label, Widget content) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        content,
      ],
    );
  }

  void _copyToClipboard(BuildContext context, String text, String message) {
    Clipboard.setData(ClipboardData(text: text));
    toastMessage(message: message);
  }

  @override
  Widget build(BuildContext context) {
    final prettyDetails =
        const JsonEncoder.withIndent('  ').convert(details ?? {});
    debugPrint("Payment details:\n$prettyDetails");

    final primaryColor =
        isOrderSuccess ? Colors.green.shade700 : Colors.orange.shade700;
    final titleText = isOrderSuccess
        ? 'Payment Successful'
        : 'Payment Completed — Order Failed';
    final subtitleText = isOrderSuccess
        ? 'Your payment was processed and the order has been created.'
        : 'Your payment was processed but we could not create the order automatically. Please contact support.';

    return Card(
      color: Colors.white,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 110.w,
              height: 110.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withValues(alpha: .12),
              ),
              child: Center(
                child: isOrderSuccess
                    ? ClipOval(
                        child: FractionallySizedBox(
                          widthFactor: 1,
                          heightFactor: 1,
                          child: Image.asset(
                            'assets/icons/download.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.info_outline,
                        color: primaryColor,
                        size: 64.w,
                      ),
              ),
            ),
            SizedBox(height: 18.h),
            if (status != null)
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.verified, color: Colors.green, size: 18),
                  const SizedBox(width: 8),
                  const Text(
                    'Payment Status:',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isOrderSuccess
                          ? Colors.green.withValues(alpha: .12)
                          : Colors.orange.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      status!,
                      style: TextStyle(
                        fontSize: 13,
                        color: isOrderSuccess
                            ? Colors.green.shade700
                            : Colors.orange.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            SizedBox(height: 12.h),
            Text(
              titleText,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              subtitleText,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: Colors.black54),
            ),
            const SizedBox(height: 18),
            if (amountPaid != null)
              Text(
                'Amount Paid: $amountPaid',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade700),
              ),
            const SizedBox(height: 12),
            if (transactionId != null ||
                status != null ||
                paymentMethod != null ||
                sessionId != null)
              Column(
                children: [
                  if (transactionId != null)
                    _infoRow(
                      context,
                      'Transaction ID:',
                      GestureDetector(
                        onTap: () => _copyToClipboard(context, transactionId!,
                            'Transaction ID copied to clipboard'),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: SelectableText(
                                transactionId!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.black87),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.copy,
                                size: 16, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                  SizedBox(height: 10.h),
                ],
              ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: isOrderSuccess ? 150 : 180.w,
                  child: isOrderSuccess
                      ? OutlinedButton.icon(
                          icon: const Icon(Icons.check,
                              color: Colors.green, size: 20),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            side: BorderSide(color: Colors.green, width: 2.5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          label: Text('Done',
                              style: TextStyle(
                                  fontSize: 16.sp, color: Colors.green)),
                          onPressed: onDone,
                        )
                      : ElevatedButton.icon(
                          icon: const Icon(Icons.mail_outline,
                              color: Colors.white),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.brightCyan,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          label: Text('Contact Us',
                              style: TextStyle(
                                  fontSize: 16.sp, color: Colors.white)),
                          onPressed: onContact,
                        ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
