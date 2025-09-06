import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:local/app/view/screens/features/vendor/products_and_category/common_widgets/image_upload_widget/image_picker_option.dart';
import '../../controller/profile_controller.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileController controller;
  final String imageUrl;
  final String name;
  final String email;
  const ProfileHeader({
    super.key,
    required this.controller,
    required this.imageUrl,
    required this.name,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Stack(
            alignment: Alignment.bottomRight,
            children: <Widget>[
              Obx(() {
                final picked = controller.pickedImage.value;
                if (picked.isNotEmpty) {
                  return CircleAvatar(
                    radius: 63,
                    backgroundImage: FileImage(File(picked)),
                  );
                }
                return CustomNetworkImage(
                  boxShape: BoxShape.circle,
                  imageUrl: imageUrl.isEmpty ? AppConstants.demoImage : imageUrl,
                  height: 125,
                  width: 126,
                );
              }),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder: (_) {
                          return DraggableScrollableSheet(
                            initialChildSize: 0.3,
                            minChildSize: 0.3,
                            maxChildSize: 0.9,
                            expand: false,
                            builder: (context, scrollController) {
                              return ImagePickerOption<ProfileController>(
                                controller: controller,
                                scrollController: scrollController,
                                onPickImage: (c, source) =>
                                    c.pickImage(source: source),
                              );
                            },
                          );
                        },
                      );
                    },
                    child: const Icon(
                      Icons.photo_library,
                      size: 24,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        Center(
          child: CustomText(
            text: name,
            fontWeight: FontWeight.w800,
            fontSize: 24.sp,
            color: AppColors.black,
          ),
        ),
        Center(
          child: CustomText(
            text: email,
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }
}