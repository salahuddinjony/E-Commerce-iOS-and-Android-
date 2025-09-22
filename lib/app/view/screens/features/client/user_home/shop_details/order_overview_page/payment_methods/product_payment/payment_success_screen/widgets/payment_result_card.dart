import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/rendering.dart';
import 'dart:typed_data';
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
  final VoidCallback? onDownload;

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
    this.onDownload,
  });

  Widget infoRow(BuildContext context, String label, Widget content) {
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

  void copyToClipboard(BuildContext context, String text, String message) {
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
        ? 'Payment Successful\n'
        : RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              children: [
                TextSpan(
                  text: 'Payment Completed\n\n',
                  style: TextStyle(color: Colors.green.shade700),
                ),
                TextSpan(
                  text: '\n',
                  style: TextStyle(fontSize: 8.sp),
                ),
                TextSpan(
                  text: 'Unfortunately Order ',
                  style: TextStyle(color: Colors.orange.shade700),
                ),
                TextSpan(
                  text: 'Failed',
                  style: TextStyle(color: Colors.red.shade700),
                ),
              ],
            ),
          );
    final subtitleText = isOrderSuccess
        ? 'Your payment was processed and the order has been created.'
        : 'Your payment was processed but we could not create the order automatically. Please contact support.';

    // For screenshot
    final GlobalKey repaintKey = GlobalKey();
    final statusLower = status?.toLowerCase();
    final bool gatewayPaymentSucceeded = statusLower != null &&
        (statusLower.contains('succeed') ||
            statusLower.contains('paid') ||
            statusLower.contains('success'));
    final bool showDownloadButton = isOrderSuccess || gatewayPaymentSucceeded;

    Future<void> _downloadReceipt() async {
      try {
        RenderRepaintBoundary boundary = repaintKey.currentContext!
            .findRenderObject() as RenderRepaintBoundary;
        // Capture at a higher pixel ratio for quality
        const double captureScale = 3.0;
        ui.Image image = await boundary.toImage(pixelRatio: captureScale);

        // Add extra padding (logical pixels) to top and bottom of the saved image
        const double extraLogicalPadding = 24.0; // change this value to increase/decrease padding
        final int padPx = (extraLogicalPadding * captureScale).round();

        // Compose a new image with white background and extra vertical padding
        final ui.PictureRecorder recorder = ui.PictureRecorder();
        final Canvas canvas = Canvas(recorder);
        final int newWidth = image.width;
        final int newHeight = image.height + padPx * 2;
        // Fill background with white so gallery shows a white receipt
        final Paint bgPaint = Paint()..color = Colors.white;
        canvas.drawRect(Rect.fromLTWH(0, 0, newWidth.toDouble(), newHeight.toDouble()), bgPaint);
        // Draw the original image centered vertically with top padding
        canvas.drawImage(image, Offset(0, padPx.toDouble()), Paint());
        final ui.Picture picture = recorder.endRecording();
        final ui.Image padded = await picture.toImage(newWidth, newHeight);

        ByteData? byteData = await padded.toByteData(format: ui.ImageByteFormat.png);
        Uint8List pngBytes = byteData!.buffer.asUint8List();

        final safeId = transactionId != null
            ? transactionId!.replaceAll(RegExp(r"[^0-9A-Za-z_-]"), "_")
            : null;
        final fileName = safeId != null
            ? 'payment_receipt_${safeId}_${DateTime.now().millisecondsSinceEpoch}'
            : 'payment_receipt_${DateTime.now().millisecondsSinceEpoch}';
        final result = await ImageGallerySaver.saveImage(pngBytes,
            quality: 100, name: fileName);
        if (result['isSuccess'] == true || result['isSuccess'] == 1) {
          toastMessage(message: 'Receipt saved to gallery');
        } else {
          toastMessage(message: 'Failed to save receipt');
        }
      } catch (e) {
        toastMessage(message: 'Error saving receipt');
      }
    }

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
            RepaintBoundary(
              key: repaintKey,
              child: Column(
                children: [
                  // Receipt header included in saved image
                  Column(
                    children: [
                      Image.asset(
                        'assets/images/u_tee.png',
                        // width: 90.w,
                        // height: 90.w,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        '${DateTime.now().toLocal().toString().split('.').first}',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 12.sp, color: Colors.black45),
                      ),
                      SizedBox(height: 12.h),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 22.h),
                    child: Container(
                      width: 110.w,
                      height: 110.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor.withOpacity(.12),
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
                  ),
                  SizedBox(height: 18.h),
                  if (status != null)
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.verified,
                            color: Colors.green, size: 18),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isOrderSuccess
                                ? Colors.green.withOpacity(.12)
                                : Colors.orange.withOpacity(.12),
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
                  isOrderSuccess
                      ? Text(
                          titleText as String,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700),
                        )
                      : titleText as RichText,
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
                          infoRow(
                            context,
                            'Transaction ID:',
                            GestureDetector(
                              onTap: () => copyToClipboard(
                                  context,
                                  transactionId!,
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
                ],
              ),
            ),
            const SizedBox(height: 25),
            if (isOrderSuccess)
              LayoutBuilder(
                builder: (context, constraints) {
                  final bool narrow = constraints.maxWidth < 360;
                  if (narrow) {
                    return Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
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
                          ),
                        ),
                        SizedBox(height: 10.h),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.download,
                                color: Colors.blue, size: 20),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.blue,
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              side: BorderSide(color: Colors.blue, width: 2.5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            label: Text('Download Receipt',
                                style: TextStyle(
                                    fontSize: 16.sp, color: Colors.blue)),
                            onPressed: () async {
                              if (onDownload != null) {
                                onDownload!();
                              } else {
                                await _downloadReceipt();
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: OutlinedButton.icon(
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
                        ),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.download,
                              color: Colors.blue, size: 20),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            side: BorderSide(color: Colors.blue, width: 2.5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          label: Text('Download Receipt',
                              style: TextStyle(
                                  fontSize: 16.sp, color: Colors.blue)),
                          onPressed: () async {
                            if (onDownload != null) {
                              onDownload!();
                            } else {
                              await _downloadReceipt();
                            }
                          },
                        ),
                      ),
                    ],
                  );
                },
              )
            else
              Column(
                children: [
                  SizedBox(
                    width: 180.w,
                    child: Column(
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.mail_outline,
                              color: Colors.white),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.brightCyan,
                            padding: EdgeInsets.symmetric(
                                vertical: 14.h, horizontal: 20.w),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          label: Text('Contact Us',
                              style: TextStyle(
                                  fontSize: 16.sp, color: Colors.white)),
                          onPressed: onContact,
                        ),
                        SizedBox(height: 10.h),
                        if (showDownloadButton)
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.download,
                                  color: AppColors.brightCyan, size: 20),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.green,
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                side: BorderSide(
                                    color: AppColors.brightCyan, width: 2.5),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              label: Text('Download Receipt',
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.brightCyan)),
                              onPressed: () async {
                                if (onDownload != null) {
                                  onDownload!();
                                } else {
                                  await _downloadReceipt();
                                }
                              },
                            ),
                          ),
                        TextButton(
                          onPressed: onDone,
                          child: Text('Done',
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  color: AppColors.brightCyan)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            
          ],

        ),
      ),
    );
  }
}
