import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/screens/vendor/home/controller/home_page_controller.dart';
import 'package:local/app/global/helper/extension/extension.dart';
import 'package:local/app/view/common_widgets/custom_loader/custom_loader.dart';

import '../../../../common_widgets/transaction_card/transaction_card_screen.dart';

class TransactionScreen extends StatelessWidget {
  TransactionScreen({super.key});

  final HomePageController controller = Get.find<HomePageController>();

  // Search query for transaction id
  final RxString searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        appBarContent: "Transactions History",
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Obx(() {
          final data = controller.walletData;

          if (!controller.balanceFetch.value && data.isEmpty) {
            return const CustomLoader();
          }
          if (data.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.receipt_long,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No transactions found',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          // Filter by transaction id (string contains)

          final filtered = data.where((tx) {
            if (searchQuery.value.isEmpty)
              return true; // No filter if search is empty , assign all
            final idStr = tx.id.toString(); // Case-sensitive match
            return idStr.contains(searchQuery.value);
          }).toList();

          return Column(
            children: [
              // Search box
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by Transaction ID',
                    prefixIcon: const Icon(Icons.search),
                    isDense: true,
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.teal, width: 1.2),
                    ),
                    suffixIcon: searchQuery.value.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchQuery.value = '';
                              searchController.clear();
                            },
                          ),
                  ),
                  onChanged: (typedValue) =>
                      searchQuery.value = typedValue.trim(),
                ),
              ),
              const SizedBox(height: 12),
              if (filtered.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No transactions match this ID',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 5),
                    itemBuilder: (context, index) {
                      final tx = filtered[index];
                      return TransactionCard(
                        title: tx.type == 'credit'
                            ? "Received Money"
                            : "Withdraw Money",
                        date: tx.transactionAt.toIso8601String().getDateTime(),
                        time:
                            "${tx.transactionAt.hour.toString().padLeft(2, '0')}:${tx.transactionAt.minute.toString().padLeft(2, '0')}",
                        type: tx.type,
                        amount: tx.amount.toString(),
                        primaryColor: Colors.teal,
                        trxId: tx.id.toString(),
                      );
                    },
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}
