// Flutter imports:
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/utils/enums/status.dart';

import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/common_widgets/custom_loader/custom_loader.dart';
import 'package:local/app/view/screens/vendor/profile/personal_info/controller/profile_controller.dart';
import 'package:local/app/view/screens/vendor/profile/personal_info/map/widgets/location_field.dart';
import 'package:local/app/view/screens/vendor/profile/personal_info/edit_profile/widgets/select_documents_button/select_documents.dart';

// New widget parts
import '../widgets/profile_header.dart';
import '../widgets/gender_dropdown.dart';
import '../widgets/contact_address_section.dart';
import '../widgets/delivery_dropdown.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();
    final data = profileController.profileModel.value;
    final id = data.profile?.id;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        appBarContent: AppStrings.editProfile,
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Obx(() {
          if (profileController.rxRequestStatus.value == Status.loading)
            return const CustomLoader();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Profile Header
                ProfileHeader(
                  controller: profileController,
                  imageUrl: id?.image ?? AppConstants.demoImage,
                  name: id?.name ?? 'User',
                  email: data.email ?? '',
                ),
                SizedBox(height: 20.h),

                // Contact Address Section
                ContactAddressSection(
                  controller: profileController,
                  id: id,
                ),
                SizedBox(height: 16.h),

                // Gender Dropdown
                GenderDropdown(controller: profileController),
                SizedBox(height: 16.h),

                // Location-address Field
                LocationField(controller: profileController),
                SizedBox(height: 16.h),

                // Delivery Dropdown
                DeliveryDropdown(controller: profileController),
                SizedBox(height: 12.h),

                // Select Documents
                SelectDocuments(
                  data: id,
                  profileController: profileController,
                ),
                SizedBox(height: 16.h),

                // Save Button
                Obx(() => CustomButton(
                      onTap: profileController.isSaving.value
                          ? null
                          : () async {
                              final ok = await profileController.saveProfile();
                              if (ok && context.mounted) context.pop();
                            },
                      title: profileController.isSaving.value
                          ? 'Saving...'
                          : AppStrings.save,
                    )),
                SizedBox(height: 20.h),
              ],
            ),
          );
        }),
      ),
    );
  }
}



