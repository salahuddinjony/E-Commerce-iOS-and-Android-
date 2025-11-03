import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/global/helper/extension/extension.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';

class TransactionCard extends StatelessWidget {
  final String title;
  final String trxId;
  final String date;
  final String time;
  final String type;
  final String amount;
  final Color primaryColor;

  const TransactionCard({
    super.key,
    required this.title,
    required this.date,
    required this.time,
    required this.type,
    required this.amount,
    this.primaryColor = Colors.teal,
    required this.trxId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.r),
      ),
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 10.h,
          horizontal: 16.w,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left: title and badge
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                title,
                                style: TextStyle(
                                  color: type == 'credit'
                                      ? AppColors.brightCyan
                                      : Colors.red,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Card(
                              elevation: 0.5,
                              color: type == 'credit' ? Colors.green : Colors.red,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                                child: Text(
                                  type.capitalizeFirstWord() + 'ed',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Right: amount
                      Padding(
                        padding: EdgeInsets.only(left: 8.w, top: 2.h),
                        child: Text(
                          "\$$amount",
                          style: TextStyle(
                            color: primaryColor.withValues(alpha: .7),
                            fontWeight: FontWeight.w800,
                            fontSize: 20.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Text(
                          'TrxID: $trxId',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 13.sp,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      GestureDetector(
                        onTap: () async {
                          await Clipboard.setData(ClipboardData(text: trxId));
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(
                                content: Text('Copied $trxId'),
                                duration: const Duration(seconds: 1),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                        },
                        child: Icon(
                          Icons.copy_rounded,
                          size: 16.sp,
                          color: Colors.grey.withValues(alpha: .7),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    '$date, $time',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 6.h),
                ],
              ),
            ),
            // ...amount is now in the first row
          ],
        ),
      ),
    );
  }
}
