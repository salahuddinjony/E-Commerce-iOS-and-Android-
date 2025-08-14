
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:local/app/data/local/shared_prefs.dart';
import 'package:local/app/services/api_client.dart';
import 'package:local/app/services/app_url.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/view/screens/vendor/home/model/wallet_data_model.dart';

class HomePageController extends GetxController {
  RxInt amount = 0.obs;
  RxList<WalletData> walletData = <WalletData>[].obs;

  final widrawAmount=TextEditingController();



  @override
  void onInit() {
    super.onInit();
    fetchWalletData();
  }

Future<void> fetchWalletData() async {
  try {
    final id = await SharePrefsHelper.getString(AppConstants.id);
    final response = await ApiClient.getData(ApiUrl.getWallet(id: id));

    print("API Response: ${response.body}");

    if (response.statusCode == 200) {
      final body = response.body; // Already a Map
      final data = body['data'];

      if (data == null) {
        print("No wallet data found");
        return;
      }

      // Balance
      amount.value = data['balance']?['amount'] ?? 0;
      print("Balance amount: ${amount.value}");

      // Transaction history
      final history = data['transactionHistory'] ?? [];
      if (history is List) {
        walletData.assignAll(
          history.map((json) => WalletData.fromJson(json)).toList(),
        );
      } else {
        walletData.clear();
      }
    } else {
      print("Failed to fetch wallet data, status: ${response.statusCode}");
    }
  } catch (e) {
    print("Error fetching wallet data: $e");
  }
}


}
