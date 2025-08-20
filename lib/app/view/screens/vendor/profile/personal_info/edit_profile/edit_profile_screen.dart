import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/common_widgets/custom_from_card/custom_from_card.dart';
import 'package:local/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:local/app/view/common_widgets/custom_loader/custom_loader.dart';
import 'package:local/app/utils/enums/status.dart';
import 'package:local/app/view/screens/vendor/profile/personal_info/controller/profile_controller.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        appBarContent: AppStrings.editProfile,
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Obx(() {
          final status = profileController.rxRequestStatus.value;
          if (status == Status.loading) {
            return const CustomLoader();
          }

          final data = profileController.profileModel.value;
          final id = data.profile?.id;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      GestureDetector(
                        onTap: profileController.pickImage,
                        child: Obx(() {
                          final picked = profileController.pickedImage.value;
                          if (picked != null) {
                            return CircleAvatar(
                              radius: 63,
                              backgroundImage: FileImage(picked),
                            );
                          }
                          return CustomNetworkImage(
                            boxShape: BoxShape.circle,
                            imageUrl: id?.image ?? AppConstants.demoImage,
                            height: 125,
                            width: 126,
                          );
                        }),
                      ),
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
                          child: const Icon(
                            Icons.photo_library,
                            size: 24,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                CustomText(
                  text: id?.name ?? 'User',
                  fontWeight: FontWeight.w800,
                  font: CustomFont.poppins,
                  fontSize: 24.sp,
                  color: AppColors.black,
                ),
                CustomText(
                  text: data.email ?? '',
                  fontWeight: FontWeight.w400,
                  font: CustomFont.poppins,
                  fontSize: 16.sp,
                  color: AppColors.black,
                ),
                SizedBox(height: 20.h),
                CustomFromCard(
                  hinText: id?.name ?? "",
                  title: AppStrings.fullName,
                  controller: profileController.fullNameController,
                  validator: (v) => null,
                ),
                CustomText(
                  textAlign: TextAlign.start,
                  font: CustomFont.inter,
                  color: AppColors.darkNaturalGray,
                  text: AppStrings.gender,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  bottom: 8.h,
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                  value: profileController.selectedGender.value.isEmpty
                      ? null
                      : profileController.selectedGender.value,
                  hint: Text(profileController.genderController.text.isEmpty
                      ? 'Select Gender'
                      : profileController.genderController.text),
                  items: const [
                    DropdownMenuItem(value: 'Male', child: Text('Male')),
                    DropdownMenuItem(value: 'Female', child: Text('Female')),
                    DropdownMenuItem(value: 'Other', child: Text('Other')),
                  ],
                  onChanged: (val) {
                    if (val != null) profileController.selectedGender.value = val;
                  },
                ),
                SizedBox(height: 12.h),
                CustomFromCard(
                  hinText: data.phone ?? "",
                  title: AppStrings.phone,
                  controller: profileController.phoneController,
                  validator: (v) => null,
                ),
                // Address
                CustomFromCard(
                  hinText: 'Rampura, Dhaka',
                  title: 'Address',
                  controller: TextEditingController(text: id?.address ?? ''),
                  validator: (v) => null,
                ),
                // Description
                CustomFromCard(
                  hinText: 'Description',
                  title: 'Description',
                  controller: TextEditingController(text: id?.description ?? ''),
                  validator: (v) => null,
                  maxLine: 3,
                ),
                // Delivery option
              
                // Location (lat,lng combined)
                CustomFromCard(
                  hinText: 'Tap to pick on map',
                  title: 'Location',
                  controller: TextEditingController(text: ''),
                  validator: (v) => null,
                ),
                         CustomText(
                  textAlign: TextAlign.start,
                  font: CustomFont.inter,
                  color: AppColors.darkNaturalGray,
                  text: 'Delivery',
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  bottom: 8.h,
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                  value: profileController.selectedDelivery.value.isEmpty
                      ? null
                      : profileController.selectedDelivery.value,
                  items: const [
                    DropdownMenuItem(value: 'pickup', child: Text('pickup')),
                    DropdownMenuItem(value: 'courier', child: Text('courier')),
                    DropdownMenuItem(value: 'pickupAndCourier', child: Text('pickupAndCourier')),
                  ],
                  hint: const Text('Select'),
                  onChanged: (val) {
                    if (val != null) profileController.selectedDelivery.value = val;
                  },
                ),
                // Status
        
                SizedBox(height: 12.h),
                // Documents picker
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: profileController.pickDocuments,
                      icon: const Icon(Icons.attach_file),
                      label: const Text('Pick Documents'),
                    ),
                    SizedBox(width: 12.w),
                    Obx(() => Text('${profileController.pickedDocuments.length} selected')),
                  ],
                ),
                SizedBox(height: 16.h),
                CustomButton(
                  onTap: () async {
                    final ok = await profileController.saveProfile();
                    if (ok && context.mounted) context.pop();
                  },
                  title: AppStrings.save,
                ),
                SizedBox(height: 20.h),
              ],
            ),
          );
        }),
      ),
    );
  }
}
