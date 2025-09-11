import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatusCard extends StatelessWidget {
  final int requestedDays; 
  final bool isApproved;
  const StatusCard(
      {super.key, required this.isApproved, required this.requestedDays});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isApproved ? Colors.green.shade100 : Colors.red.shade100,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        'You ${isApproved ? "accepted" : "rejected"} a $requestedDays-day extension',
        style: TextStyle(
          color: isApproved ? Colors.green.shade700 : Colors.red.shade700,
          fontWeight: FontWeight.w600,
          fontSize: 14.sp,
        ),
      ),
    );
  }
}
