import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:image_picker/image_picker.dart';

class BusinessDocumentsController extends GetxController {
  // List of uploaded image file names, null if not uploaded
  // Store both file name and file path for preview
  RxList<XFile?> uploadedFiles = List<XFile?>.filled(3, null).obs;

  final ImagePicker _picker = ImagePicker();

  void pickFile(int index) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      uploadedFiles[index] = image;
      update();
    }
  }

  void clearFile(int index) {
    uploadedFiles[index] = null;
    update();
  }
}

class BusinessDocumentsScreen extends StatelessWidget {
  const BusinessDocumentsScreen({super.key});

  List<Map<String, String>> get _items => [
        {
          'title': 'Upload Business License & Tax Info',
        },
        {
          'title': 'Bank Account Details for Payouts',
        },
        {
          'title': 'Withdrawal History & Earnings Report',
        },
      ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BusinessDocumentsController>(
      init: BusinessDocumentsController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: const CustomAppBar(
            appBarContent: "Business Documents",
            iconData: Icons.arrow_back,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: ListView.separated(
              itemCount: _items.length,
              separatorBuilder: (_, __) => SizedBox(height: 14.h),
              itemBuilder: (context, index) {
                final item = _items[index];
                final uploadedFile = controller.uploadedFiles[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(12.r),
                  onTap: () {
                    controller.pickFile(index);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 34.r,
                          height: 34.r,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: CustomText(
                            text: "${index + 1}",
                            font: CustomFont.poppins,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: item['title'] ?? '',
                                font: CustomFont.poppins,
                                fontWeight: FontWeight.w500,
                                fontSize: 16.sp,
                                color: AppColors.darkNaturalGray,
                                maxLines: 2,
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                children: [
                                  if (uploadedFile != null) ...[
                                    Icon(Icons.insert_drive_file, size: 18.sp, color: Theme.of(context).colorScheme.primary),
                                    SizedBox(width: 6.w),
                                    Expanded(
                                      child: CustomText(
                                        text: uploadedFile.name,
                                        font: CustomFont.poppins,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.sp,
                                        color: AppColors.darkNaturalGray,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(width: 6.w),
                                    GestureDetector(
                                      onTap: () => controller.clearFile(index),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.redAccent.withOpacity(0.12),
                                          shape: BoxShape.circle,
                                        ),
                                        padding: EdgeInsets.all(4),
                                        child: Icon(Icons.clear, size: 18.sp, color: Colors.redAccent),
                                      ),
                                    ),
                                  ] else ...[
                                    CustomText(
                                      text: 'No file uploaded',
                                      font: CustomFont.poppins,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.sp,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(
                          Icons.upload_file,
                          size: 22.sp,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
