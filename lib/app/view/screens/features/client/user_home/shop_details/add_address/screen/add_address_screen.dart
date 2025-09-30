import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/widgets/custom_order_field.dart';

import '../../../../../../../../core/route_path.dart';

class AddAddressScreen extends StatelessWidget {
  final String vendorId;
  final String productId;
  final String productName;
  final String productCategoryName;
  final dynamic controller;
  final bool isCustomOrder;
  final String productImage;

  const AddAddressScreen({
    super.key,
    required this.vendorId,
    this.productId = '',
    this.productName = '',
    this.productCategoryName = '',
    required this.controller,
    required this.isCustomOrder,
    required this.productImage,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint("Passed Image to AddAddressScreen: $productImage");
    debugPrint('AddAddressScreen for vendorId: $vendorId');
    debugPrint('isCustomOrder: $isCustomOrder');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: isCustomOrder
            ? const Text("Offer Custom Order")
            : const Text('Add Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // show custom order fields if isCustomOrder is true
              isCustomOrder
                  ? CustomOrderField(controller: controller)
                  : const SizedBox(),

              if (!isCustomOrder) ...[
                const Text('Recipient’s Name',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: controller.customerNameController,
                  decoration: InputDecoration(
                    hintText: 'Real name',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const Text('Contact Number',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: controller.customerPhoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    hintText: 'Phone Number',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('City/Region',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: controller.customerRegionCityController,
                  decoration: InputDecoration(
                    hintText: 'city/region',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              const Text('Address',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: controller.customerAddressController,
                decoration: InputDecoration(
                  hintText: 'House no./building/area',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Obx(() {
                final submitting = controller.isSubmitting?.value ?? false;
                return CustomButton(
                  onTap: () async {
                    if (isCustomOrder) {
                      if (controller.checkCustomOrderInisEmpty()) return;
                      try {
                        EasyLoading.show(status: 'Creating order...');
                        final success = await controller.createCustomOrder(
                          vendorId: vendorId,
                        );
                        if (success) {
                          EasyLoading.showSuccess('Order created successfully');
                          // context.goNamed(RoutePath.homeScreen);
                          context.pop();
                        } else {
                          EasyLoading.showError('Failed to create order');
                        }
                      } catch (e) {
                        debugPrint('Error creating order: $e');
                        EasyLoading.showError('Error: ${e.toString()}');
                      }
                      return;
                    }
                    // For general order, navigate to order overview
                    context.pushNamed(
                      RoutePath.orderOverviewScreen,
                      extra: {
                        'vendorId': vendorId,
                        'productId': productId,
                        'controller': controller,
                        'ProductImage': productImage,
                        'isCustomOrder': isCustomOrder,
                        'productName': productName,
                        'productCategoryName': productCategoryName,
                      },
                    );
                  },
                  title: submitting
                      ? "Creating..."
                      : isCustomOrder
                          ? "Create Custom Order"
                          : "Next",
                );
              }),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
