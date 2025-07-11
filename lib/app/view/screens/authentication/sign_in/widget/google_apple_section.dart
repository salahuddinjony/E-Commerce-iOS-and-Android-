import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/route_path.dart';
import '../../../../../utils/app_strings/app_strings.dart';
import '../../../../../utils/custom_assets/assets.gen.dart';
import '../../../../common_widgets/custom_auth_container/custom_auth_container.dart' show CustomAuthContainer;
import '../../../../common_widgets/custom_rich_text/custom_rich_text.dart';

class GoogleAppleSection extends StatelessWidget {
  const GoogleAppleSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CustomAuthContainer(
        buttonText: AppStrings.signUpWithGoogle,
        // Text for the button
        onPressed: () {
          // Handle Google authentication logic here
          print('Google Sign-Up button pressed');
        },
        image: Assets.images.google.image(),
      ),
      SizedBox(
        height: 14.h,
      ),
      CustomAuthContainer(
        buttonText: AppStrings.signUpWithApple,
        // Text for the button
        onPressed: () {
          // Handle Google authentication logic here
          print('Google Sign-Up button pressed');
        },
        image: Assets.images.apple.image(),
      ),
      SizedBox(
        height: 14.h,
      ),
      CustomRichText(
          firstText: AppStrings.dontHaveAnAccount,
          secondText: AppStrings.signUp,
          onTapAction: () {
            context.pushNamed(
              RoutePath.signUpScreen,
            );
          })
    ],);
  }
}