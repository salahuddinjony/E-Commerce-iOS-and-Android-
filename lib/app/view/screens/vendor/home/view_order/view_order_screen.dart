import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';

import '../../../../../core/route_path.dart';
import '../../../../common_widgets/order_card/order_card.dart';

class ViewOrderScreen extends StatelessWidget {
  const ViewOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        appBarContent: "Total Orders",
        iconData: Icons.arrow_back,
      ),
      body: ListView.builder(
        padding:  EdgeInsets.symmetric(horizontal: 20.h, vertical: 10.w),
        itemCount: 5,
        itemBuilder: (context, index) {
          return OrderCard(
            parcelId: '#626365',
            date: '10-03-2025',
            addressLine1: 'America',
            deliveryType: 'Delivery Type: Cash',
            amount: 10,
            timeAgo: '04 Hours ago',
            imageUrl: AppConstants.demoImage,
            onTap: () {
              context.pushNamed(
                RoutePath.viewOrderDetails,
              );
            },
          );
        },
      ),
    );
  }
}
