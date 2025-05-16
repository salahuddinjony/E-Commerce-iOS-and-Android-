import 'package:flutter/material.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';

import '../../../../common_widgets/transaction_card/transaction_card_screen.dart';



class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        appBarContent: "Transactions History",
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            TransactionCard(
              title: 'Receive Money',
              date: '12-03-2025',
              time: '12 PM',
              relativeTime: '1 days ago',
              amount: '\$60.23',
              primaryColor: Colors.teal, // optional
            ),


          ],
        ),
      ),
    );
  }
}
