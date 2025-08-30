import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:local/app/view/screens/vendor/profile/personal_info/edit_profile/widgets/select_documents_button/documents_button.dart';
import 'package:local/app/view/screens/vendor/profile/personal_info/edit_profile/widgets/select_documents_button/upload_doc_button.dart';
import 'dart:math' as math; // <--- added import

class SelectDocuments<T> extends StatelessWidget {
  final bool? isUpload;
  final T genericCOntroller;
  final dynamic data; //dymamic is nullable

  SelectDocuments({
    Key? key,
    required this.genericCOntroller,
    this.data, 
    this.isUpload,
  }) : super(key: key); 

  @override
  Widget build(BuildContext context) {
    final controller = genericCOntroller as dynamic;
    final id = data is String ? null : data ?? null; // Handle both cases
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
            text: isUpload != null ? isUpload! ? 'Uploaded Documents' : 'Documents' : 'Documents',
            textAlign: TextAlign.start,
            font: CustomFont.inter,
            color: AppColors.darkNaturalGray,
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            bottom: 12.h,
          ),
          // (Removed global linear progress bar; using per-chip circular progress only)

          // Responsive Row: use LayoutBuilder and Flexible so children don't overflow
          LayoutBuilder(builder: (context, constraints) {
            final maxW = constraints.maxWidth;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Make this a Flexible child of the Row (Flex parent) instead of arbitrary ConstrainedBox
                Flexible(
                  flex: 3,
                  fit: FlexFit.loose,
                  child: SizedBox(
                    width: maxW * 0.75,
                    child: UploadDocButton<T>(
                      genericCOntroller: controller,
                      id: id,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                // The selected-count box as the remaining flexible child
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.brightCyan),
                    ),
                    child: Obx(() {
                      final picked = controller.pickedDocuments;
                      final existing = (id?.documents ?? []) as List<dynamic>;
                      final total =
                          picked.isNotEmpty ? picked.length : existing.length;
                      // FittedBox prevents the Text from expanding beyond the container
                      return FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '$total selected',
                          style: TextStyle(
                            color: AppColors.brightCyan,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            );
          }),

          // New: clickable chips for existing documents (shown only when no new picks)
          data != null
              ? Obx(() {
                  final picked = controller.pickedDocuments;
                  final existing = (id?.documents ?? []) as List<dynamic>;
                  if (picked.isNotEmpty || existing.isEmpty)
                    return const SizedBox.shrink();

                  final showAll = controller.showAllExisting.value;
                  final visibleList =
                      showAll ? existing : existing.take(3).toList();

                  // Use LayoutBuilder here so each chip can be constrained relative to available width
                  return Padding(
                    padding: EdgeInsets.only(top: 12.h),
                    child: LayoutBuilder(builder: (context, constraints) {
                      final maxW = constraints.maxWidth;
                      return Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ...visibleList.map((e) {
                            // Use SizedBox with a computed width (no Flexible/Expanded inside Wrap)
                            final chipMax = math.min(maxW * 0.55, 220.w);
                            return SizedBox(
                              width: chipMax,
                              child: buildDocChip(e.toString(), controller),
                            );
                          }),
                          if (!showAll && existing.length > 3)
                            ActionChip(
                              backgroundColor: Colors.white,
                              label: Text('+${existing.length - 3} more'),
                              onPressed: () =>
                                  controller.showAllExisting.toggle(),
                            ),
                          if (showAll && existing.length > 3)
                            ActionChip(
                              backgroundColor: Colors.white,
                              label: const Text('Show less'),
                              onPressed: () =>
                                  controller.showAllExisting.toggle(),
                            ),
                        ],
                      );
                    }),
                  );
                })
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
