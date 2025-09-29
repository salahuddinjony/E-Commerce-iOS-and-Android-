import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/product_details/controller/product_details_controller.dart';
import 'package:local/app/view/screens/features/vendor/profile/personal_info/edit_profile/widgets/delivery_dropdown.dart';
import 'package:local/app/view/screens/features/vendor/profile/personal_info/edit_profile/widgets/select_documents_button/select_documents.dart';

class CustomOrderField extends StatelessWidget {
  final ProductDetailsController controller;
  const CustomOrderField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Design Files',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),

        // Document Picker
        SelectDocuments<ProductDetailsController>(
          genericCOntroller: controller,
          isUpload: true,
        ),

        const SizedBox(height: 8),
        const Text('Price(\$)', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller.priceController,
          decoration: InputDecoration(
            hintText: 'Price in USD',
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const Text('Quantities', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller.quantityController,
          decoration: InputDecoration(
            hintText: 'Enter Quantities',
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        DeliveryDropdown(controller: controller),
        SizedBox(height: 12.h),
        const SizedBox(height: 16),
        const Text('Delivery Date',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        // Replaced GestureDetector + child TextField with a single readOnly TextField that uses onTap
        TextField(
          controller: controller.deliveryDate,
          readOnly: true,
          onTap: () async {
            await controller.selectDeliveryDate(context);
          },
          decoration: InputDecoration(
            hintText: 'Select Delivery Date',
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 16),

        const Text('Summery Of the Order',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller.summeryController,
          decoration: InputDecoration(
            hintText: 'Summery Of the Order',
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
