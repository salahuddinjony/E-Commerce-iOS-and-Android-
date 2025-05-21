import 'package:flutter/material.dart';

import '../../../../utils/app_colors/app_colors.dart';
import '../../../common_widgets/owner_nav/owner_nav.dart';

class VendorMessageScreen extends StatelessWidget {
  const VendorMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: OwnerNav(
        currentIndex:3 ,
      ),
    );
  }
}
