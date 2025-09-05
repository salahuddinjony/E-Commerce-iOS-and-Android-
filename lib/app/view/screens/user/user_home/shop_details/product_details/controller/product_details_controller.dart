import 'package:get/get.dart';
import 'package:flutter/widgets.dart';

class ProductDetailsController extends GetxController {
  final double basePrice;
  // basePrice is now passed in via constructor
  ProductDetailsController({required this.basePrice});

  final items = 1.obs;
  final size = ''.obs;
  final color = ''.obs;

  final standardShipping = false.obs;
  final expressShipping = false.obs;
  final homeDelivery = false.obs;

  final TextEditingController itemsTextController = TextEditingController();

  // Ordered customer info
  final TextEditingController customerNameController = TextEditingController(text: "Salah Uddin");
  final TextEditingController customerPhoneController = TextEditingController(text: "01712345678");
  final TextEditingController customerRegionCityController =
      TextEditingController(text: "Dhaka");
  final TextEditingController customerAddressController = TextEditingController(text: "123 Main St, Dhaka");

// Shipping costs and hub fee percentage
  final double standardShippingCost = 10;
  final double expressShippingCost = 10;
  final double homeDeliveryCost = 8;
  final double hubFeePercent = 0.2;

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
      if (itemsTextController.text == newText) return;
      itemsTextController.text = newText;
    });
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
  double get priceOfItems=>(basePrice * items.value);
  double get subTotal => priceOfItems + shippingCost;
  double get totalCost => subTotal + (subTotal * hubFeePercent);

  @override
  void onClose() {
    super.onClose();
    itemsTextController.dispose();
    customerNameController.dispose();
    customerPhoneController.dispose();
    customerRegionCityController.dispose();
    customerAddressController.dispose();
  }
}
