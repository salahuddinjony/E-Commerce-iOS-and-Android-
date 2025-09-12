import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class ActionButtonController extends GetxController {
  final isLoadingForExtn = false.obs;
}

class StatusActionButton extends StatelessWidget {
  final FutureOr<void> Function()? onClick;
  final dynamic controller;
  final String label;
  const StatusActionButton({super.key, this.onClick, this.controller, required this.label});

  bool mainControllerLoading(dynamic mainCtrl) {
    try {
      final val = mainCtrl?.isLoadingForExtn;
      if (val is RxBool) return val.value;
      return false;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAccept = label.toLowerCase() == 'accept';

    // per-label action controller (separate loading for each button)
    final ActionButtonController actionCtrl;
    final tag = const Uuid().v4(); // Unique tag for each button instance


    if (Get.isRegistered<ActionButtonController>(tag: tag)) {
      actionCtrl = Get.find<ActionButtonController>(tag: tag);
    } else {
      actionCtrl = Get.put<ActionButtonController>(ActionButtonController(), tag: tag);
    }

    return Obx(
      () {
        // Only include main controller loading if the main controller was explicitly registered with this label tag.
        final bool mainCtrlLoading = (controller != null && Get.isRegistered<dynamic>(tag: tag))
            ? mainControllerLoading(Get.find<dynamic>(tag: tag))
            : false;

        final combinedLoading = actionCtrl.isLoadingForExtn.value || mainCtrlLoading;

        return ElevatedButton.icon(
          onPressed: onClick == null
              ? null
              : () async {
                  actionCtrl.isLoadingForExtn.value = true;
                  try {
                    final dynamic result = onClick!();
                    if (result is Future) {
                      await result;
                    }
                  } finally {
                    actionCtrl.isLoadingForExtn.value = false;
                  }
                },
          icon: combinedLoading
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
            shadowColor: Colors.greenAccent.withValues(alpha: .15),
            minimumSize: Size(0, 32.h),
          ),
        );
      },
    );
  }
}
