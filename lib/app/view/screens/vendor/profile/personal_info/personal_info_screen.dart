import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';

import '../../../../../core/route_path.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        isIcon: true,
        onTap: (){
          context.pushNamed(
            RoutePath.editProfileScreen,
          );
        },
        appBarContent: AppStrings.profile,
        iconData: Icons.arrow_back,

      ),
    );
  }
}
