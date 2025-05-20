import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/common_widgets/custom_from_card/custom_from_card.dart';
import 'package:local/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:local/app/view/common_widgets/custom_text_field/custom_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController fullNameController =
      TextEditingController(text: "Albert Stevano Bajefski");
  TextEditingController genderController = TextEditingController(text: "Male");
  TextEditingController phoneController =
      TextEditingController(text: "+01722983926");
  TextEditingController emailController =
      TextEditingController(text: "masu@gmail.com");

  void _showGenderDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select Gender"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Male"),
                onTap: () {
                  setState(() {
                    genderController.text = "Male";
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Female"),
                onTap: () {
                  setState(() {
                    genderController.text = "Female";
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Other"),
                onTap: () {
                  setState(() {
                    genderController.text = "Other";
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        appBarContent: AppStrings.editProfile,
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CustomNetworkImage(
                    boxShape: BoxShape.circle,
                    imageUrl: AppConstants.demoImage,
                    height: 125,
                    width: 126,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        // TODO: Implement gallery picker logic here
                        print("Gallery icon tapped");
                      },
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
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
                        child: Icon(
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
            CustomText(
              text: 'Gwen Stacy',
              fontWeight: FontWeight.w800,
              font: CustomFont.poppins,
              fontSize: 24.sp,
              color: AppColors.black,
            ),
            CustomText(
              text: '@GwenStacy31',
              fontWeight: FontWeight.w400,
              font: CustomFont.poppins,
              fontSize: 16.sp,
              color: AppColors.black,
            ),
            SizedBox(height: 20.h),
         Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [

             CustomFromCard(
               hinText: "Albert Stevano Bajefski",
               title: AppStrings.fullName,
               controller: fullNameController,
               validator: (v) {},
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
             CustomTextField(
               inputTextStyle: const TextStyle(color: AppColors.black),
               textEditingController: genderController,
               prefixIcon: const Icon(Icons.person),
               // Add prefix icon
               suffixIcon: GestureDetector(
                 onTap: _showGenderDialog,
                 child: const Icon(
                     Icons.arrow_drop_down), // Arrow icon to open dialog
               ),
               readOnly: true,
             ),
             SizedBox(height: 12.h,),
             CustomFromCard(
               hinText: "+01722983926",
               title: AppStrings.phone,
               controller: phoneController,
               validator: (v) {},
             ),
             CustomFromCard(
               hinText: "masu@gmail.com",
               title: AppStrings.email,
               controller: emailController,
               validator: (v) {},
             ),
             CustomButton(
               onTap: () {
                 context.pop();
               },
               title: AppStrings.save,
             ),
           ],
         )
          ],
        ),
      ),
    );
  }
}
