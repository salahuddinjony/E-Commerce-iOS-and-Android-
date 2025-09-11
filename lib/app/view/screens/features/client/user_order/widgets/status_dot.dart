import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatusDot extends StatelessWidget {
  final Color color;
  final IconData icon;
  final bool isLatest;

  const StatusDot({Key? key, required this.color, required this.icon, this.isLatest = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: isLatest ? 4 : 2,
      shape: CircleBorder(),
      color: Colors.white,
      child: Container(
        width: isLatest ? 36.w : 28.w,
        height: isLatest ? 36.w : 28.w,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            if (isLatest)
              BoxShadow(
                color: color.withOpacity(.25),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: isLatest ? 18.sp : 14.sp,
        ),
      ),
    );
  }
}