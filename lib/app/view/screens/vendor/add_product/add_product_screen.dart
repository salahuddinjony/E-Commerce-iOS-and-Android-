import 'package:flutter/material.dart';

import '../../../../utils/app_colors/app_colors.dart';
import '../../../common_widgets/custom_appbar/custom_appbar.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        iconData: Icons.arrow_back,
        appBarContent: "Add Product",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }
}
