import 'package:flutter/material.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';


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
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        itemCount:15,
        itemBuilder: (context, index) {
          return  OrderCard(
            parcelId: '#626365',
            date: '10-03-2025',
            addressLine1: 'America',
            deliveryType: 'Delivery Type: Cash',
            amount: 10,
            timeAgo: '04 Hours ago',
            imageUrl: AppConstants.demoImage,
          );
        },
      ),
    );
  }
}


