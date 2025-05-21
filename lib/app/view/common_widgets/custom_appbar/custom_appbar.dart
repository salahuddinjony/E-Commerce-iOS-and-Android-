
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/custom_assets/assets.gen.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final double appBarHeight;
  final double? appBarWidth;
  final Color appBarBgColor;
  final String? appBarContent;
  final IconData? iconData;
  final bool isIcon;
  final VoidCallback? onTap;

  const CustomAppBar({
    this.appBarHeight = 64,
    this.appBarWidth,
    this.appBarBgColor = AppColors.white,
    this.appBarContent,
    super.key,
    this.iconData,
    this.isIcon = false,
    this.onTap,   t // Default to false
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size(appBarWidth ?? double.infinity, appBarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor:AppColors.white,
      backgroundColor: widget.appBarBgColor,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          children: [
            if (widget.iconData != null)
              IconButton(
                icon: Icon(widget.iconData),
                color: AppColors.black,
                onPressed: () {
                  context.pop();
                },
              ),
            if (widget.appBarContent != null)
              Expanded(
                child: CustomText(
                  text: widget.appBarContent!,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w500,
                  fontSize: 22,
                  color: AppColors.black,
                ),
              ),
            if (widget.isIcon)
              GestureDetector(
                onTap: widget.onTap,
                child: Assets.icons.edit.svg(
                  colorFilter:
                  const ColorFilter.mode(AppColors.black, BlendMode.srcIn),
                ),
              ),


          ],
        ),
      ),
    );
  }
}
