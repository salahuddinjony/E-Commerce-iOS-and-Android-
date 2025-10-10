import 'package:flutter/material.dart';
import 'package:get/get.dart';
 Widget showMoreDataLoader(dynamic controller) {
    return Obx(() {
      if (controller.isPaginating.value) {
        // Show loading indicator when loading more data
        return Container(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(height: 12),
                Text(
                  'Loading more...'.tr,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        );
      } else if (!controller.hasMoreData.value &&
          controller.bookingReportList.isNotEmpty) {
        // Show "no more data" message when all data is loaded
        return Container(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(height: 1, width: 30, color: Colors.grey[300]),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'No more data'.tr,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Container(height: 1, width: 30, color: Colors.grey[300]),
              ],
            ),
          ),
        );
      }
      return SizedBox.shrink();
    });
  }