import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:local/app/view/screens/vendor/profile/personal_info/controller/profile_controller.dart';
import 'package:local/app/view/screens/vendor/profile/personal_info/edit_profile/widgets/select_documents_button/documents_button.dart';
import 'package:local/app/view/screens/vendor/profile/personal_info/edit_profile/widgets/select_documents_button/upload_doc_button.dart';


class SelectDocuments extends StatelessWidget {
  final ProfileController profileController;
  final dynamic data;
  // Local reactive state for expanding/collapsing existing documents
  final RxBool _showAllExisting = false.obs;

  SelectDocuments({
    Key? key,
    required this.profileController,
    this.data,
  }) : super(key: key);

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
          // (Removed global linear progress bar; using per-chip circular progress only)
          Row(
            children: [
              UploadDocButton(
                profileController: profileController,
                id: id,
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

            final showAll = _showAllExisting.value;
            final visibleList = showAll ? existing : existing.take(3).toList();

            return Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...visibleList.map(
                      (e) => buildDocChip(e.toString(), profileController)),
                  if (!showAll && existing.length > 3)
                    ActionChip(
                      backgroundColor: Colors.white,
                      label: Text('+${existing.length - 3} more'),
                      onPressed: () => _showAllExisting.toggle(),
                    ),
                  if (showAll && existing.length > 3)
                    ActionChip(
                      backgroundColor: Colors.white,
                      label: const Text('Show less'),
                      onPressed: () => _showAllExisting.toggle(),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
