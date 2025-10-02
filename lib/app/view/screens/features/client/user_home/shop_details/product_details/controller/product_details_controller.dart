import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
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

// for the picke design document
  Rx<File?> selectedDocument = Rx<File?>(null);
  final RxBool showAllExisting = false.obs;
  final RxList<File> pickedDocuments = <File>[].obs;
  Future<void> pickDocuments() async {
    final picker = ImagePicker();
    final files = await picker.pickMultipleMedia();
    if (files.isNotEmpty) {
      pickedDocuments.assignAll(files.map((e) => File(e.path)));
      // keep a single selectedDocument for legacy callers (first file)
      selectedDocument.value =
          pickedDocuments.isNotEmpty ? pickedDocuments.first : null;
    }
  }

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
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController customerPhoneController = TextEditingController();
  final TextEditingController customerRegionCityController =
      TextEditingController();
  final TextEditingController customerAddressController =
      TextEditingController();

  void clearCustomerInfo() {
    customerNameController.clear();
    customerPhoneController.clear();
    customerRegionCityController.clear();
    customerAddressController.clear();
  }

  // clear picked/selected design files
  void clearPickedDocuments() {
    pickedDocuments.clear();
    selectedDocument.value = null;
  }

  // convenience to reset selections and customer info after sending
  void clearAfterSend() {
    clearCustomerInfo();
    clearPickedDocuments();
    deliveryDate.clear();
    summeryController.clear();
    priceController.clear();
    quantityController.clear();
    selectedDelivery.value = '';
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

  bool checkCustomOrderInisEmpty() {
    if (pickedDocuments.isEmpty && selectedDocument.value == null) {
      EasyLoading.showInfo("Please select at least one design file");
      return true;
    }
    if (customerAddressController.text.isEmpty) {
      EasyLoading.showInfo("Please fill the Address field");
      return true;
    }
    if (priceController.text.isEmpty ||
        double.tryParse(priceController.text) == null ||
        double.parse(priceController.text) <= 0) {
      EasyLoading.showInfo("Invalid item price");
      return true;
    }
    if (quantityController.text.isEmpty ||
        int.tryParse(quantityController.text) == null ||
        int.parse(quantityController.text) <= 0) {
      EasyLoading.showInfo("Invalid item quantity");
      return true;
    }
    if (summeryController.text.isEmpty) {
      EasyLoading.showInfo(
          "Please provide a brief description of your custom order");
      return true;
    }
    if (selectedDelivery.value.isEmpty) {
      EasyLoading.showInfo("Please specify your preferred delivery option");
      return true;
    }
    if (deliveryDate.text.isEmpty) {
      EasyLoading.showInfo("Please specify a valid delivery date");
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
    // clear fields on successful creation
    if (response == true) {
      clearAfterSend();
    }
    return response;
  }

  // Future<bool> createCustomOrder(
  //     {required String vendorId, dynamic? localImage}) async {
  //   isSubmitting.value = true;
  //   try {
  //     // show loading via EasyLoading (UI can also observe isSubmitting)
  //     // Note: UI may show its own loading, but having EasyLoading here ensures feedback even if UI doesn't
  //     // EasyLoading.show(status: 'Creating order...');
  //     final response = await customOrder(
  //       vendorId: vendorId,
  //       shippingAddress: "Address:" +
  //           customerAddressController.text.trim() +
  //           ", City/Region:" +
  //           customerRegionCityController.text.trim() +
  //           ", Phone:" +
  //           customerPhoneController.text.trim() +
  //           ", Name:" +
  //           customerNameController.text.trim(),
  //       localImage: localImage,
  //     );
  //     return response;
  //   } finally {
  //     isSubmitting.value = false;
  //   }
  // }
  Future<bool> createCustomOrder({required String clientId}) async {
    isSubmitting.value = true;
    try {
      // if multiple files were picked, prefer sending the list; otherwise send single selectedDocument
      final dynamic filesToSend = pickedDocuments.isNotEmpty
          ? pickedDocuments.toList()
          : selectedDocument.value;

      final response = await customOrder(
        clientId: clientId,
        shippingAddress: customerAddressController.text.trim(),
        designFiles: filesToSend,
      );
      // clear fields and selected images on success
      if (response == true) {
        clearAfterSend();
      }
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

  Future<void> selectDeliveryDate(BuildContext context) async {
    // determine initial date from current text (format: dd-MM-yyyy) or use now

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      helpText: "Select New Delivery Date",
      builder: (context, child) => Theme(
        data: ThemeData(
          datePickerTheme: DatePickerThemeData(
            headerBackgroundColor: AppColors.brightCyan,
            backgroundColor: Colors.white,
            headerForegroundColor: Colors.white,
          ),
        ),
        child: child ?? const SizedBox.shrink(),
      ),
    );

    if (pickedDate != null) {
      // use ISO-like format YYYY-MM-DD so backend can cast to Date
      final formattedDate =
          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      deliveryDate.text = formattedDate;
      deliveryDate.selection = TextSelection.fromPosition(
        TextPosition(offset: deliveryDate.text.length),
      );
    }
  }
}
