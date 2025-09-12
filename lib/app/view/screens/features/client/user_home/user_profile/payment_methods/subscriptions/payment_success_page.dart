import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/product_details/controller/product_details_controller.dart';

class PaymentSuccessPage extends StatelessWidget {
  final String? transactionId;
  final String? chargeId;
  final String? status;
  final String? paymentMethod;
  final String? sessionId;
  final String? amountPaid;
  final Map<String, dynamic>? details;

  const PaymentSuccessPage({
    super.key,
    this.transactionId,
    this.chargeId,
    this.status,
    this.paymentMethod,
    this.sessionId,
    this.amountPaid,
    this.details,
  });

  @override
  Widget build(BuildContext context) {
    final prettyDetails = const JsonEncoder.withIndent('  ').convert(details ?? {});
    debugPrint("Payment details:\n$prettyDetails");


    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        // wrap the Column in Center so the whole block stays centered,
        // and use MainAxisSize.min so the Column doesn't try to fill vertical space
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             const SizedBox(height: 18),
             Image.asset('assets/icons/download.png', height: 180),
             const SizedBox(height: 8),
            const Text(
              'Payment Successful',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
             const SizedBox(height: 16),
 
             if (amountPaid != null)
              Text(
                'Amount Paid: $amountPaid',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.green),
              ),
             if (transactionId != null)
               Padding(
               padding: const EdgeInsets.only(top: 8),
               child: SelectableText(
                'Transaction ID: $transactionId',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
               ),
             if (status != null)
               Padding(
               padding: const EdgeInsets.only(top: 4),
               child: Text(
                'Status: $status',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
               ),
             const SizedBox(height: 50),
 
             // Constrain button width without affecting other children
             SizedBox(
               width: 220.w, // adjust this value to the desired button width
               child: OutlinedButton.icon(
                 style: OutlinedButton.styleFrom(
                   foregroundColor: AppColors.brightCyan,
                   side: const BorderSide(color: AppColors.brightCyan, width: 2),
                   minimumSize: Size(0, 48.h), // keep height, allow width from SizedBox
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                   textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                 ),
                 icon: const Icon(Icons.check_circle_outline, color:AppColors.brightCyan),
                 label: const Text('Done'),
                 onPressed: () {
                  // Clear ProductDetailsController so tag-wise store product info is cleared
                  final controller = Get.isRegistered<ProductDetailsController>()
                      ? Get.find<ProductDetailsController>()
                      : null;
                  controller?.clearSelections(); // Make sure you have a clear() method in your controller that resets all relevant fields
                  Get.delete<ProductDetailsController>(force: true);
                  Navigator.of(context).popUntil((route) => route.isFirst);
                 },
               ),
             ),
            // SizedBox(height: 80.h),
            ],
          ),
        ),
           
       ),
     );
   }
 }