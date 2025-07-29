
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local/app/global/helper/validators/validators.dart';
import 'package:local/app/view/screens/authentication/controller/auth_controller.dart';
import '../../../../../core/route_path.dart';
import '../../../../../core/routes.dart';
import '../../../../common_widgets/custom_button/custom_button.dart';
import 'ducument_file.dart';
import 'label_text_field.dart';

class BusinessVendorForm extends StatefulWidget {
  final AuthController controller;

  const BusinessVendorForm({super.key, required this.controller});

  @override
  State<BusinessVendorForm> createState() => _BusinessVendorFormState();
}

class _BusinessVendorFormState extends State<BusinessVendorForm> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabeledTextField(
            label: 'Business Name',
            hintText: 'Business Name',
            controller: widget.controller.businessNameController,
            icon: Icons.business_center,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Business name is required';
              }
              return null;
            },
          ),
          LabeledTextField(
              label: 'Business E-mail',
              hintText: 'Business E-mail',
              controller: widget.controller.businessEmailController,
              icon: Icons.email,
              validator: Validators.emailValidator),
          LabeledTextField(
            label: 'Business Phone Number',
            hintText: 'Phone Number',
            controller: widget.controller.businessPhoneController,
            icon: Icons.phone,
            validator: Validators.phoneNumberValidator,
          ),
          LabeledTextField(
            label: 'Delivery Option',
            hintText: 'Select',
            controller: widget.controller.businessDeliveryOptionController,
            icon: Icons.delivery_dining,
            isDropdown: true,
            dropdownOptions: const ['pickup', 'courier', 'pickupAndCourier'],
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Select Delivery Option';
              }
              return null;
            },
          ),

          LabeledTextField(
            label: 'Description',
            hintText: 'Type here',
            controller: widget.controller.businessDescriptionController,
            icon: Icons.description,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Description here';
              }
              return null;
            },
          ),
          LabeledTextField(
            label: 'Address',
            hintText: 'Type here',
            controller: widget.controller.businessAddressController,
            icon: Icons.location_on,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Address is Required';
              }
              return null;
            },
          ),


          DocumentPickerField(
            label: 'Upload Document',
            controller: authController.docController,
            onFilePicked: (file) {
              authController.selectedDocument.value = file;
              debugPrint('File path: ${file.path}');
            },
          ),
          SizedBox(height: 20.h),

          /// Submit Button
          CustomButton(
            onTap: () {
              if (_formKey.currentState!.validate()) {
                AppRouter.route.pushNamed(RoutePath.nextScreen);
              }
            },
            title: "Next",
          ),

          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}




