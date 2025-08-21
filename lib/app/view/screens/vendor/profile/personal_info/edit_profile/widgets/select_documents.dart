import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:local/app/view/screens/vendor/profile/personal_info/controller/profile_controller.dart';

class SelectDocuments extends StatelessWidget {
  final ProfileController profileController;
  final dynamic data;
  const SelectDocuments({
    Key? key,
    required this.profileController, this.data,
  });

  @override
  Widget build(BuildContext context) {
    final id = data is String ? null : data; // Handle both cases
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Documents',
            textAlign: TextAlign.start,
            font: CustomFont.inter,
            color: AppColors.darkNaturalGray,
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            bottom: 12.h,
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: profileController.pickDocuments,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.brightCyan,
                    side: BorderSide(color: AppColors.brightCyan, width: 1.5),
                    padding:
                        EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: Icon(Icons.attach_file,
                      size: 20, color: AppColors.brightCyan),
                  label: Obx(() {
                    final documents = profileController.pickedDocuments;
                    final existingDocuments =
                        (id?.documents ?? []) as List<dynamic>;
                    String fileNameFromUrl(String url) {
                      try {
                        final uri = Uri.parse(url); // Parse the URL
                        if (uri.pathSegments.isNotEmpty) {
                          return uri.pathSegments
                              .last; // Get the last segment of the path
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
                            style: TextStyle(
                                fontSize: 14.sp, fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          );
                        } else {
                          return Text(
                            '${existingDocuments.length} documents',
                            style: TextStyle(
                                fontSize: 14.sp, fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          );
                        }
                      }
                      return Text(
                        'Pick Documents',
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.w500),
                      );
                    } else if (documents.length == 1) {
                      return Text(
                        documents.first.path.split('/').last,
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      );
                    } else {
                      return Text(
                        '${documents.length} documents selected',
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      );
                    }
                  }),
                ),
              ),
              SizedBox(width: 16.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.brightCyan),
                ),
                child: Obx(() {
                  final picked = profileController.pickedDocuments;
                  final existing = (id?.documents ?? []) as List<dynamic>;
                  final total =
                      picked.isNotEmpty ? picked.length : existing.length;
                  return Text(
                    '$total selected',
                    style: TextStyle(
                      color: AppColors.brightCyan,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  );
                }),
              ),
            ],
          ),

          // New: clickable chips for existing documents (shown only when no new picks)
          Obx(() {
            final picked = profileController.pickedDocuments;
            final existing = (id?.documents ?? []) as List<dynamic>;
            if (picked.isNotEmpty || existing.isEmpty)
              return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...existing.take(3).map((e) {
                    final url = e.toString();
                    final name = url.split('/').last;
                    return InkWell(
                      onTap: () => profileController.openDocument(url),
                      child: Chip(
                        backgroundColor: Colors.white,
                        label: SizedBox(
                          width: 120.w,
                          child: Text(
                            name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        avatar: const Icon(Icons.insert_drive_file, size: 18),
                        deleteIcon: const Icon(Icons.download, size: 18),
                        onDeleted: () => profileController.openDocument(url),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    );
                  }).toList(),
                  if (existing.length > 3)
                    Chip(
                      backgroundColor: Colors.white,
                      label: Text('+${existing.length - 3} more'),
                    )
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
