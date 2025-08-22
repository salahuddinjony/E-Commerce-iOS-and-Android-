import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:local/app/view/screens/vendor/profile/personal_info/controller/profile_controller.dart';

Widget buildDocChip(String url, ProfileController profileController) {
  final name = url.split('/').last;
  return Obx(() {
    final isThisDownloading = profileController.isDownloading.value &&
        profileController.downloadingFileName.value == name;
    final progress = profileController.downloadProgress.value;
    final percent = (progress * 100).clamp(0, 100).toInt();
    return InkWell(
      onTap: () => profileController.openDocument(url),
      child: Chip(
        backgroundColor: Colors.white,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        label: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 170.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.insert_drive_file, size: 18),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 6.w),
              if (!isThisDownloading)
                GestureDetector(
                  onTap: () => profileController.openDocument(url),
                  child: const Icon(Icons.download, size: 18),
                )
              else
                SizedBox(
                  width: 28,
                  height: 28,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        strokeWidth: 3,
                        value: progress == 0 ? null : progress,
                      ),
                      Text(
                        '$percent%',
                        style: TextStyle(
                            fontSize: 9.sp, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  });
}
