import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:local/app/view/common_widgets/product_color_list/mixin_product_color.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/product_details/controller/mixin_create_order.dart';

class ProductDetailsController extends GetxController
    with ProductColorMixin, MixinCreateOrder {
  final double basePrice;
  // basePrice is now passed in via constructor
  ProductDetailsController({required this.basePrice});

  // submission state for custom/general orders
  final isSubmitting = false.obs;

  final standardShipping = false.obs;
  final expressShipping = false.obs;
  final homeDelivery = false.obs;

  void clearSelections() {
    size.value = '';
    color.value = '';
    items.value = 1;
    standardShipping.value = false;
    expressShipping.value = false;
    homeDelivery.value = false;
  }

  final TextEditingController itemsTextController = TextEditingController();

  // Ordered customer info
  final TextEditingController customerNameController =
      TextEditingController(text: "Salah Uddin");
  final TextEditingController customerPhoneController =
      TextEditingController(text: "01712345678");
  final TextEditingController customerRegionCityController =
      TextEditingController(text: "Dhaka");
  final TextEditingController customerAddressController =
      TextEditingController(text: "123 Main St, Dhaka");

  void clearCustomerInfo() {
    customerNameController.clear();
    customerPhoneController.clear();
    customerRegionCityController.clear();
    customerAddressController.clear();
  }

  bool checkCustomerInfoIsEmpty() {
    if (customerNameController.text.isEmpty ||
        customerPhoneController.text.isEmpty ||
        customerRegionCityController.text.isEmpty ||
        customerAddressController.text.isEmpty) {
      String missingField = '';
      if (customerNameController.text.isEmpty) {
        missingField = 'Name';
      } else if (customerPhoneController.text.isEmpty) {
        missingField = 'Phone';
      } else if (customerRegionCityController.text.isEmpty) {
        missingField = 'Region/City';
      } else if (customerAddressController.text.isEmpty) {
        missingField = 'Address';
      }
      EasyLoading.showInfo("Please fill the $missingField field");
      return true;
    }
    return false;
  }

// Constants for Shipping costs and hub fee percentage
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

// Calculate shipping cost based on selected options
  double get shippingCost {
    double v = 0;
    if (standardShipping.value) v += standardShippingCost;
    if (expressShipping.value) v += expressShippingCost;
    if (homeDelivery.value) v += homeDeliveryCost;
    return v;
  }

  // Cost calculations
  double get priceOfItems => (basePrice * items.value);
  double get subTotal => priceOfItems + shippingCost;
  double get hubfee => subTotal * hubFeePercent;
  double get totalCost => subTotal + hubfee;

  Future<bool> createGeneralOrder(
      {required String productId,
      required String vendorId,
      required String sessionId}) async {
    final response = await createOrder(
      ProductId: productId,
      vendorId: vendorId,
      price: basePrice.toInt(),
      quantity: items.value,
      shippingAddress: "Address:" +
          customerAddressController.text.trim() +
          ", City/Region:" +
          customerRegionCityController.text.trim() +
          ", Phone:" +
          customerPhoneController.text.trim() +
          ", Name:" +
          customerNameController.text.trim(),
      sessionId: sessionId,
    );
    return response;
  }

  Future<bool> createCustomOrder(
      {required String vendorId, dynamic localImage}) async {
    isSubmitting.value = true;
    try {
      // show loading via EasyLoading (UI can also observe isSubmitting)
      // Note: UI may show its own loading, but having EasyLoading here ensures feedback even if UI doesn't
      // EasyLoading.show(status: 'Creating order...');
      final response = await customOrder(
        vendorId: vendorId,
        shippingAddress: "Address:" +
            customerAddressController.text.trim() +
            ", City/Region:" +
            customerRegionCityController.text.trim() +
            ", Phone:" +
            customerPhoneController.text.trim() +
            ", Name:" +
            customerNameController.text.trim(),
        localImage: localImage,
      );
      return response;
    } finally {
      isSubmitting.value = false;
    }
  }

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
