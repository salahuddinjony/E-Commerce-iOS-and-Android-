import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/global/helper/extension/extension.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/screens/features/vendor/orders/models/custom_order_response_model.dart';
import '../controller/view_order_details_controller.dart';

class ExtensionHistory extends StatelessWidget {
  final Order order;
  final ViewOrderDetailsController controller;
  const ExtensionHistory(
      {super.key, required this.order, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (order.extentionHistory.isEmpty) return const SizedBox.shrink();

    final ext = order.extentionHistory.last;
    final status = (ext.status).toLowerCase();
    Color bg;
    Color border;
    IconData icon;
    if (status == 'pending') {
      bg = Colors.orange[50]!;
      border = Colors.orange;
      icon = Icons.hourglass_top;
    } else if (status == 'approved' || status == 'accepted') {
      bg = Colors.green[50]!;
      border = Colors.green;
      icon = Icons.check_circle;
    } else if (status == 'rejected' || status == 'declined') {
      bg = Colors.red[50]!;
      border = Colors.red;
      icon = Icons.cancel;
    } else {
      bg = Colors.grey[50]!;
      border = AppColors.brightCyan;
      icon = Icons.history;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Last Extension History",
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 10.h),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Card(
            elevation: 1,
            color: bg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: border, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: border),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Previous: ${ext.lastDate.formatDate()}",
                            style: TextStyle(fontSize: 14.sp)),
                        SizedBox(height: 6.h),
                        Text("New: ${ext.newDate.formatDate()}",
                            style: TextStyle(fontSize: 14.sp)),
                        SizedBox(height: 6.h),
                        Text(
                          "+${controller.formatDuration(ext.newDate.difference(ext.lastDate))}",
                          style: TextStyle(
                              fontSize: 13.sp, fontWeight: FontWeight.w600),
                        ),
                        if ((ext.reason).isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text("Reason: ${ext.reason}",
                                style: TextStyle(
                                    fontSize: 13.sp, color: Colors.black87)),
                          ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Chip(
                        label: Text(ext.status.toUpperCase(),
                            style: TextStyle(fontSize: 11.sp, color: border)),
                        backgroundColor: border.withValues(alpha: .12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}
