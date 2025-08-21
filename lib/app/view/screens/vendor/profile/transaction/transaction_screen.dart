import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/screens/vendor/home/controller/home_page_controller.dart';
import 'package:local/app/global/helper/extension/extension.dart';
import 'package:local/app/view/common_widgets/custom_loader/custom_loader.dart';
import 'package:local/app/view/common_widgets/no_internet/no_internet.dart';

import '../../../../common_widgets/transaction_card/transaction_card_screen.dart';



class TransactionScreen extends StatelessWidget {
   TransactionScreen({super.key});
  final controller=Get.find<HomePageController>();

  @override
  Widget build(BuildContext context) {
   
    // print(data);
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        appBarContent: "Transactions History",
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Obx(
          () {
            final data = controller.walletData;
            if (!controller.balanceFetch.value && data.isEmpty) {
              return const CustomLoader();
            }
            // if (data.isEmpty && controller.message.value.isNotEmpty) {
            //   return NoInternetScreen(onTap: controller.fetchWalletData);
            // }
            if (data.isEmpty) {
              return const Center(child: Text('No transactions found'));
            }
            return ListView.separated(
              itemCount: data.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return TransactionCard(
                  title: data[index].type == 'credit' ? "Received Money" : "Withdraw Money",
                  date: data[index].transactionAt.toIso8601String().getDateTime(),
                  time: "${data[index].transactionAt.hour.toString().padLeft(2, '0')}:${data[index].transactionAt.minute.toString().padLeft(2, '0')}",
                  type: data[index].type,
                  amount: data[index].amount.toString(),
                  primaryColor: Colors.teal,
                );
              },
            );
          }
        ),
      ),
    );
  }
}
