import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/screens/features/client/user_order/widgets/days_badge.dart';
class ContentExpandedCard extends StatelessWidget {
  final controller;
  final String status;
  final String newDate;
  final String lastDate;
  final String reason;
  final dynamic newDateRaw;
  final dynamic lastDateRaw;
  final bool isLatest;
  final Color color;
  const ContentExpandedCard({
    super.key,
    required this.controller,
    required this.status,
    required this.newDate,
    required this.lastDate,
    required this.reason,
    required this.newDateRaw,
    required this.lastDateRaw,
    required this.isLatest,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .03),
                  blurRadius: 1,
                  offset: Offset(3, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // header row with status chip and newDate
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: .12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        status.toUpperCase(),
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                    Spacer(),
                    Text(
                      newDate,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                // from -> to row with subtle divider
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14.sp,
                      color: Colors.grey[500],
                    ),
                    SizedBox(width: 8.w),
                    Flexible(
                      child: Text(
                        'From: $lastDate  ',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey[800],
                        ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_right_alt,
                        size: 18.sp,
                        color: Colors.grey[600],
                      ),
                      Flexible(
                        child: Text(
                        'To: $newDate',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                // reason text
                if (reason.isNotEmpty)
                  Text(
                    reason,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey[800],
                    ),
                  ),
                SizedBox(height: 10.h),

                // footer row with extra meta (days extended)
                Row(
                  children: [
                    if (lastDateRaw is DateTime && newDateRaw is DateTime)
                      DaysBadge(days: newDateRaw.difference(lastDateRaw).inDays),
                    Spacer(),
                    if (isLatest)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: AppColors.brightCyan.withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'CURRENT',
                          style: TextStyle(
                            color: AppColors.brightCyan,
                            fontWeight: FontWeight.w700,
                            fontSize: 11.sp,
                          ),
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