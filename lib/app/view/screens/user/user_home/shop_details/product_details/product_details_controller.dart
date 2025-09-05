import 'package:get/get.dart';
import 'package:flutter/widgets.dart';

class ProductDetailsController extends GetxController {
  final items = 1.obs;
  final size = ''.obs;
  final color = ''.obs;

  final standardShipping = false.obs;
  final expressShipping = false.obs;
  final homeDelivery = false.obs;

  final double basePrice = 20.22;
  final double standardShippingCost = 10;
  final double expressShippingCost = 10;
  final double homeDeliveryCost = 8;
  final double hubFeePercent = 0.2;


  final TextEditingController itemsTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    itemsTextController.text = items.value.toString();

    // When user types in text field, update the items value (enforce min 1)
    itemsTextController.addListener(() {
      final txt = itemsTextController.text.trim();
      if (txt.isEmpty) return;
      final parsed = int.tryParse(txt);
      if (parsed == null) return;
      final value = parsed < 1 ? 1 : parsed;
      if (items.value != value) {
        items.value = value;
      }
    });

    // When items changes (via buttons), update text field
    ever<int>(items, (val) {
      final newText = val.toString();
      // Avoid rewriting the same text (prevents cursor jump / needless events)
      if (itemsTextController.text == newText) return;
      itemsTextController.text = newText;
      itemsTextController.selection = TextSelection.fromPosition(
        TextPosition(offset: itemsTextController.text.length),
      );
    });
  }

  @override
  void onClose() {
    itemsTextController.dispose();
    super.onClose();
  }

  void increment() => items.value++;
  void decrement() {
    if (items.value > 1) items.value--;
  }

  void selectSize(String s) => size.value = s;
  void selectColor(String c) => color.value = c;

  void toggleStandard(bool v) => standardShipping.value = v;
  void toggleExpress(bool v) => expressShipping.value = v;
  void toggleHomeDelivery(bool v) => homeDelivery.value = v;

  double get shippingCost {
    double v = 0;
    if (standardShipping.value) v += standardShippingCost;
    if (expressShipping.value) v += expressShippingCost;
    if (homeDelivery.value) v += homeDeliveryCost;
    return v;
  }

  double get subTotal => basePrice * items.value + shippingCost;
  double get totalCost => subTotal + subTotal * hubFeePercent;
}
