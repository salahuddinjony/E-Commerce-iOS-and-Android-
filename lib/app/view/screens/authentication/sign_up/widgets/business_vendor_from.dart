import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/global/helper/validators/validators.dart';
import 'package:local/app/view/screens/authentication/controller/auth_controller.dart';
import '../../../../common_widgets/loading_button/loading_button.dart';
import 'label_text_field.dart';

class BusinessVendorForm extends StatelessWidget {
  final AuthController controller;

  BusinessVendorForm({super.key, required this.controller});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
            controller: controller.businessNameController,
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
            controller: controller.businessEmailController,
            icon: Icons.email,
            validator: Validators.emailValidator
          ),
          LabeledTextField(
            label: 'Business Phone Number',
            hintText: 'Phone Number',
            controller: controller.businessPhoneController,
            icon: Icons.phone,
            validator: Validators.phoneNumberValidator,
          ),
          LabeledTextField(
            label: 'Delivery Option',
            hintText: 'Select',
            controller: controller.businessDeliveryOptionController,
            icon: Icons.delivery_dining,
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
            controller: controller.businessDescriptionController,
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
            controller: controller.businessAddressController,
            icon: Icons.location_on,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Address is Required';
              }
              return null;
            },
          ),
          LabeledTextField(
            label: 'Documents',
            hintText: 'Upload documents',
            controller: TextEditingController(),
            // Consider using a separate controller if needed
            icon: Icons.upload_file,
            readOnly: true,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'documents  is required';
              }
              return null;
            },
          ),
          SizedBox(height: 20.h),

          /// Submit Button
          LoadingButton(
            isLoading: controller.isVendorLoading,
            onTap: () {
              if (_formKey.currentState!.validate()) {
                controller.vendorSIgnUp(context);
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
