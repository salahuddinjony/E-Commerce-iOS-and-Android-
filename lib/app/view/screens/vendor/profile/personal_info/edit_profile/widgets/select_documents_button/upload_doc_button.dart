import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/screens/vendor/profile/personal_info/controller/profile_controller.dart';

class UploadDocButton extends StatelessWidget {

  final ProfileController profileController;
  final dynamic id;

  const UploadDocButton({
    Key? key,
    required this.profileController,
    this.id
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: profileController.pickDocuments,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.brightCyan,
          side: BorderSide(color: AppColors.brightCyan, width: 1.5),
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        icon: Icon(Icons.attach_file, size: 20, color: AppColors.brightCyan),
        label: Obx(() {
          final documents = profileController.pickedDocuments;
          final existingDocuments = (id?.documents ?? []) as List<dynamic>;
          String fileNameFromUrl(String url) {
            try {
              final uri = Uri.parse(url); // Parse the URL
              if (uri.pathSegments.isNotEmpty) {
                return uri
                    .pathSegments.last; // Get the last segment of the path
              }
              return url;
            } catch (_) {
              return url;
            }
          }

          if (documents.isEmpty) {
            if (existingDocuments.isNotEmpty) {
              if (existingDocuments.length == 1) {
                return Text(
                  fileNameFromUrl(existingDocuments.first.toString()),
                  style:
                      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                );
              } else {
                return Text(
                  '${existingDocuments.length} documents',
                  style:
                      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                );
              }
            }
            return Text(
              'Pick Documents',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            );
          } else if (documents.length == 1) {
            return Text(
              documents.first.path.split('/').last,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            );
          } else {
            return Text(
              '${documents.length} documents selected',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            );
          }
        }),
      ),
    );
  }
}
