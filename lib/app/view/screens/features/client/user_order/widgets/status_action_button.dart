import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class StatusActionButton extends StatelessWidget {
  final VoidCallback? onClick;
  final controller;
  final String label;
  const StatusActionButton({super.key, this.onClick, this.controller, required this.label});

  @override
  Widget build(BuildContext context) {
    final isAccept=label=='Accept';
    return  Obx(
      ()=> ElevatedButton.icon(
      onPressed: onClick,
      icon: controller.isLoadingForExtn.value
          ? SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 1.5,
              ),
            )
          : isAccept
              ? Icon(Icons.check_circle_outline, color: Colors.white, size: 16.sp)
              : Icon(Icons.cancel, color: Colors.white, size: 16.sp),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isAccept ? Colors.green.shade600 : Colors.red.shade600,
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        shadowColor: Colors.greenAccent.withValues( alpha: .15), 
        minimumSize: Size(0, 32.h),
      ),
    ),
    );
  }
}
