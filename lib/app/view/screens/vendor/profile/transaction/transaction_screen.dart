import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/screens/vendor/home/controller/home_page_controller.dart';
import 'package:local/app/global/helper/extension/extension.dart';
import 'package:local/app/view/common_widgets/custom_loader/custom_loader.dart';
import 'package:local/app/view/screens/vendor/profile/wallet/empty_state.dart';
import 'package:local/app/view/screens/vendor/profile/wallet/search_field.dart';

import '../../../../common_widgets/transaction_card/transaction_card_screen.dart';

class TransactionScreen extends StatelessWidget {
  TransactionScreen({super.key});

  final HomePageController homeController = Get.find<HomePageController>();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.brightCyan,
      backgroundColor: Colors.white,
      onRefresh: () async {
        await homeController.fetchWalletData();
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: const CustomAppBar(
          appBarContent: "Transactions History",
          iconData: Icons.arrow_back,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Obx(() {
            final data = homeController.walletData;

            if (!homeController.balanceFetch.value && data.isEmpty) {
              return const CustomLoader();
            }
            if (data.isEmpty) {
              return EmptyState(
                icon: Icons.receipt_long,
                text: 'No transactions found',
              );
            }

            final filtered = data.where((tx) {
              // Type filter
              if (homeController.filterType.value != null &&
                  tx.type != homeController.filterType.value) {
                return false;
              }
              // Search filter
              if (homeController.searchQuery.value.isEmpty) return true;
              return tx.id
                  .toString()
                  .contains(homeController.searchQuery.value);
            }).toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SearchField(homeController: homeController),
                ),
                const SizedBox(height: 8),
                // Active filter badge (visible only when a filter is selected)
                Obx(() {
                  if (!homeController.hasFilter) return const SizedBox.shrink();
                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 6),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.teal.withValues(alpha: .08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.teal.withValues(alpha: .35)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.filter_list,
                            size: 18, color: Colors.teal),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Active filter: ${homeController.activeFilterLabel}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.teal,
                            ),
                          ),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: homeController.clearFilter,
                          child: const Padding(
                            padding: EdgeInsets.all(4.0),
                            child:
                                Icon(Icons.close, size: 18, color: Colors.teal),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                // Optional: show count summary
                Obx(() {
                  // Recompute filtered length here consistent with list below
                  final data = homeController.walletData;
                  final filteredCount = data.where((tx) {
                    if (homeController.filterType.value != null &&
                        tx.type != homeController.filterType.value)
                      return false;
                    if (homeController.searchQuery.value.isNotEmpty &&
                        !tx.id
                            .toString()
                            .contains(homeController.searchQuery.value)) {
                      return false;
                    }
                    return true;
                  }).length;
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                        text: TextSpan(
                      text: 'Showing ',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                      children: [
                        TextSpan(
                          text: '$filteredCount',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.teal,
                          ),
                        ),
                        const TextSpan(text: ' transactions'),
                      ],
                    )),
                  );
                }),
                const SizedBox(height: 6),
                if (filtered.isEmpty)
                  Expanded(
                    child: EmptyState(
                      icon: Icons.search_off,
                      text: 'No transactions match filters',
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
                          date:
                              tx.transactionAt.toIso8601String().getDateTime(),
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
      ),
    );
  }
}
