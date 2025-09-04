import 'package:get/get.dart';

class ProductDetailsController extends GetxController {
  final items = 1.obs;
  final size = 'S'.obs;

  final standardShipping = false.obs;
  final expressShipping = false.obs;
  final homeDelivery = false.obs;

  final double basePrice = 20.22;
  final double standardShippingCost = 10;
  final double expressShippingCost = 10;
  final double homeDeliveryCost = 8;
  final double hubFeePercent = 0.2;

  void increment() => items.value++;
  void decrement() {
    if (items.value > 1) items.value--;
  }

  void selectSize(String s) => size.value = s;

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
