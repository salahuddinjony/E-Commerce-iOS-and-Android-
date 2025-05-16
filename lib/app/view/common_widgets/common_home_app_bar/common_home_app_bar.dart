import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/utils/custom_assets/assets.gen.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';

class CommonHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonHomeAppBar({
    super.key,
    required this.scaffoldKey,
    required this.onTap, required this.aboutUsOnTap, required this.privacyTap, required this.termsTap, required this.profileTap,
  });

  final VoidCallback onTap;
  final VoidCallback aboutUsOnTap;
  final VoidCallback privacyTap;
  final VoidCallback termsTap;
  final VoidCallback profileTap;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 150.h,
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 26.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Assets.images.logo.image(height: 113.h, width: 100.w),
            Assets.images.uTee.image(),
            GestureDetector(
                onTap: profileTap,
                child: Assets.images.profile.image(height: 40.h, width: 40.w)),
          ],
        ),
      ),
      actions: [
        Builder(builder: (context) {
          return IconButton(
            onPressed: () {
              final RenderBox button = context.findRenderObject() as RenderBox;
              final RenderBox overlay =
              Overlay.of(context).context.findRenderObject() as RenderBox;
              final Offset position =
              button.localToGlobal(Offset.zero, ancestor: overlay);

              showMenu(
                color: AppColors.white,
                context: context,
                position: RelativeRect.fromLTRB(
                  position.dx,
                  position.dy + button.size.height,
                  overlay.size.width - position.dx,
                  0,
                ),
                items: [
                  PopupMenuItem(
                    height: 33.h,
                    onTap: aboutUsOnTap,
                    child: SizedBox(
                      width: 200.w,
                      child: Row(
                        children: [
                          CustomText(
                            text: AppStrings.aboutUs,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.darkNaturalGray,
                          ),
                          const Spacer(),
                          Assets.icons.arrow.svg(),
                        ],
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    height: 33.h,
                    onTap: privacyTap,
                    child: SizedBox(
                      width: 200.w,
                      child: Row(
                        children: [
                          CustomText(
                            text: AppStrings.privacyPolicy,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.darkNaturalGray,
                          ),
                          const Spacer(),
                          Assets.icons.arrow.svg(),
                        ],
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    height: 34.h,
                    onTap: termsTap,
                    child: SizedBox(
                      width: 200.w,
                      child: Row(
                        children: [
                          CustomText(
                            text: AppStrings.termsOfService,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.darkNaturalGray,
                          ),
                          const Spacer(),
                          Assets.icons.arrow.svg(),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
          );
        }),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(150.h);
}
