import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';

class OrderCard extends StatelessWidget {
  final String parcelId;
  final String date;
  final String addressLine1;
  final String deliveryType;
  final double amount;
  final String timeAgo;
  final String imageUrl;
  final VoidCallback? onTap;
  final Color color;

  const OrderCard({
    super.key,
    required this.parcelId,
    required this.date,
    required this.addressLine1,
    required this.deliveryType,
    required this.amount,
    required this.timeAgo,
    required this.imageUrl,
    this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: deliveryType == 'Completed' || deliveryType == 'Cancelled' ? null : onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          border:
              Border.all(color: AppColors.allSideColor.withValues(alpha: .2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                imageUrl,
                width: 56.w,
                height: 56.w,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 56.w,
                  height: 56.w,
                  color: AppColors.allSideColor.withValues(alpha: 0.1),
                  alignment: Alignment.center,
                  child: Icon(Icons.image_not_supported,
                      size: 20.sp, color: AppColors.darkNaturalGray),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // First row: ID + Date
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          parcelId,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkNaturalGray,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Flexible(
                        child: Text(
                          date,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  if (addressLine1.isNotEmpty)
                    Text(
                      addressLine1,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          deliveryType,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: color,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        '\$${amount.toStringAsFixed(2)}',
                        maxLines: 1,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 13.sp,
                          color: AppColors.darkNaturalGray,
                        ),
                      ),
                    ],
                  ),
                  if (timeAgo.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Text(
                      timeAgo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            // Chevron
            SizedBox(width: 4.w),

            CircleAvatar(
              radius: 14.r,
              backgroundColor: deliveryType != 'Completed'
                  ? deliveryType != 'Cancelled'
                      ? theme.colorScheme.primary.withValues(alpha: .2)
                      :theme.colorScheme.primary.withValues(alpha: .2)
                  : const Color.fromARGB(255, 30, 156, 118)
                      .withValues(alpha: .5),
              child: Icon(
                deliveryType != 'Completed'
                    ? deliveryType != 'Cancelled'
                        ? Icons.chevron_right_rounded
                        : Icons.close_rounded
                    : Icons.check_rounded,
                size: 18.sp,
                color:
                    deliveryType != 'Completed' ?  deliveryType != 'Cancelled'
                        ? Colors.black : Colors.red
                        : Colors.white,
              ),
            ),
            SizedBox(width: 8.w),
            // GestureDetector(
            //    onTap: () async {
            //     await Clipboard.setData(ClipboardData(text: parcelId));
            //     ScaffoldMessenger.of(context)
            //       ..hideCurrentSnackBar()
            //       ..showSnackBar(
            //         SnackBar(
            //           content: Text('Copied $parcelId'),
            //           duration: const Duration(seconds: 1),
            //           behavior: SnackBarBehavior.floating,
            //         ),
            //       );
            //   },
            //   child: Icon(
            //     Icons.copy_rounded, size: 18.sp, color: Colors.grey.withValues(alpha: .5)
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
