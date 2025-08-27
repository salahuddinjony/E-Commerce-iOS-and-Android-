import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:local/app/core/routes.dart';
import 'package:local/app/data/local/shared_prefs.dart';
import 'package:local/app/services/api_client.dart';
import 'package:local/app/services/app_url.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/view/screens/vendor/home/model/wallet_data_model.dart';
import 'package:local/app/view/screens/vendor/profile/transaction/mixin/mixin_transaction_screen.dart';

class HomePageController extends GetxController with MixinTransactionScreen {
  RxInt amount = 0.obs;
  RxBool balanceFetch = false.obs;
  RxList<TransactionHistory> walletData = <TransactionHistory>[].obs;
  final withdrawAmount = TextEditingController();
  RxString message = ''.obs;


  @override
  void onInit() {
    super.onInit();
    fetchWalletData();

    // Add listener for real-time validation
    withdrawAmount.addListener(validateWithdrawAmount);
  }

  @override
  void onClose() {
    withdrawAmount.removeListener(validateWithdrawAmount);
    withdrawAmount.dispose();
    super.onClose();
  }

  Future<void> fetchWalletData() async { 
    try {
      final id = await SharePrefsHelper.getString(AppConstants.userId);

      final response = await ApiClient.getData(ApiUrl.getWallet(id: id));
      print("API Response: ${response.body}");

      if (response.statusCode == 200) {
        final body = response.body; // Assuming body is already a Map
        final data = body['data'];

        if (data == null) {
          balanceFetch.value = true;
          print("No wallet data found");
          message.value = "No wallet data available";
          return;
        }

        // Balance
        amount.value = data['balance']['amount'] ?? 0;
        balanceFetch.value = true;
        print("Balance amount: ${amount.value}");

        // Transaction history
        final history = data['transactionHistory'];
        if (history is List) {
          walletData.assignAll(
            history.map((json) => TransactionHistory.fromJson(json)).toList(),
          );
        } else {
          walletData.clear();
        }
      } else {
        balanceFetch.value = true;
        print("Failed to fetch wallet data, status: ${response.statusCode}");
        message.value = "Failed to fetch wallet data";
      }
    } catch (e) {
      balanceFetch.value = true;
      print("Error fetching wallet data: $e");
    } finally {
      // Ensure loading state is reset
      // EasyLoading.dismiss();
    }
  }

  void validateWithdrawAmount() {
    final text = withdrawAmount.text;
    if (text.isEmpty) {
      message.value = "Please enter a withdrawal amount";
      return;
    }

    final amountToWithdraw = int.tryParse(text);
    if (amountToWithdraw == null || amountToWithdraw <= 0) {
      message.value = "Please enter a valid amount";
      return;
    }

    if (amountToWithdraw > amount.value) {
      message.value = "Insufficient balance";
      return;
    }

    message.value = "";
  }

  Future<void> withdraw() async {
    // validateWithdrawAmount(); // Validate before proceeding
    if (message.value.isNotEmpty) {
      return;
    }

    try {
      if (withdrawAmount.text.isEmpty) {
        message.value = "Please enter a withdrawal amount";
        return;
      }
      EasyLoading.show(status: 'Processing withdrawal...');
      final body = {
        'amount': double.parse(withdrawAmount.text),
        "currency": "usd",
      };
      final response =
          await ApiClient.postData(ApiUrl.withdrawWallet, jsonEncode(body));

      if (response.statusCode == 200) {
        // Refresh wallet data after withdrawal
         fetchWalletData();
        EasyLoading.showSuccess("Withdrawal request submitted");
        clearWithdrawAmount();
        AppRouter.route.pop();
      } else {
        message.value = "Error processing withdrawal, Try again later";
      }
    } catch (e) {
      print("Error processing withdrawal: $e");
      EasyLoading.showError("Error processing withdrawal, Try again later");
      AppRouter.route.pop();
      message.value = "Error processing withdrawal, Try again later";
    } finally {
      EasyLoading.dismiss();
    }
  }

  void clearWithdrawAmount() {
    withdrawAmount.clear();
    message.value = '';
  }
}
