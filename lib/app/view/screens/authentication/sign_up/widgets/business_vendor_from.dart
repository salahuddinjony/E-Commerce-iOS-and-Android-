import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/global/helper/validators/validators.dart';
import 'package:local/app/view/screens/authentication/controller/auth_controller.dart';
import 'package:local/app/view/screens/vendor/profile/personal_info/edit_profile/widgets/select_documents_button/select_documents.dart';
import 'package:local/app/view/common_widgets/map/widgets/location_field.dart';
import '../../../../../core/route_path.dart';
import '../../../../../core/routes.dart';
import '../../../../common_widgets/custom_button/custom_button.dart';
import 'ducument_file.dart';
import 'label_text_field.dart';

class BusinessVendorForm extends StatelessWidget {
  final AuthController controller;

  const BusinessVendorForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Form(
      key: formKey,
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
            validator: Validators.emailValidator,
          ),
          LabeledTextField(
            label: 'Business Phone Number',
            hintText: 'Phone Number',
            controller: controller.businessPhoneController,
            icon: Icons.phone,
            validator: Validators.phoneNumberValidator,
          ),
          //   LabeledTextField(
          //   label: 'Gender',
          //   hintText: 'Select',
          //   controller: controller.businessGenderController,
          //   icon: Icons.delivery_dining,
          //   isDropdown: true,
          //   dropdownOptions: const ['Male', 'Female', 'Other'],
          //   validator: (value) {
          //     if (value == null || value.trim().isEmpty) {
          //       return 'Select Gender';
          //     }
          //     return null;
          //   },
          // ),
          LabeledTextField(
            label: 'Delivery Option',
            hintText: 'Select',
            controller: controller.businessDeliveryOptionController,
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
            controller: controller.businessDescriptionController,
            icon: Icons.description,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Description here';
              }
              return null;
            },
          ),
        //google map
          LocationField<AuthController>(
            controller: controller,
          ),


          SizedBox(height: 20.h),

          // Document Picker
           SelectDocuments<AuthController>(
              genericCOntroller: controller,
              isUpload: true,
            ),


          SizedBox(height: 20.h),
          /// Submit Button
          CustomButton(
            onTap: () {
              if (formKey.currentState!.validate()) {
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




