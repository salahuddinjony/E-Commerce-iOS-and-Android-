import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:local/app/view/screens/features/vendor/orders/constants/order_constants.dart';

class OrderItemCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final String description;
  final bool isActive;
  final String? status;

  const OrderItemCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.description,
    this.isActive = false, 
    this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyleTitle = TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 16.sp,
      color: Colors.black,
    );

    final textStyleSubtitle = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12.sp,
      color: Colors.grey[600],
    );

    final textStyleDescription = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12.sp,
      color: Colors.grey[700],
      height: 1.3,
    );

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomNetworkImage(
            imageUrl: imagePath,
            height: 127,
            width: 119,
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: textStyleTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (status != null) ...[
                      SizedBox(width: 8.w),
                      Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: status != null ? Color(OrderConstants.getStatusColor(status!)) : Colors.green.shade700,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          status!,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                          ),
                        ),  
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 2.h),
                Text(subtitle, style: textStyleSubtitle),
                SizedBox(height: 6.h),
                Text(description, style: textStyleDescription),
              ],
            ),
          ),
        ],
      ),
    );
  }
}