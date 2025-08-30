// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:local/app/utils/app_colors/app_colors.dart';
// import 'package:local/app/utils/app_strings/app_strings.dart';
// import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
// import '../../controller/profile_controller.dart';

// class GenderDropdown extends StatelessWidget {
//   final ProfileController controller;
//   const GenderDropdown({super.key, required this.controller});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         CustomText(
//           text: AppStrings.gender,
//           fontWeight: FontWeight.w600,
//           fontSize: 16.sp,
//           color: AppColors.darkNaturalGray,
//           bottom: 8.h,
//         ),
//         DropdownButtonFormField<String>(
//           dropdownColor: Colors.white,
//           decoration: const InputDecoration(
//             border: OutlineInputBorder(),
//             isDense: true,
//             contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//           ),
//           value: controller.selectedGender.value.isEmpty
//               ? null
//               : controller.selectedGender.value,
//           hint: Text(
//             controller.genderController.text.isEmpty
//                 ? 'Select Gender'
//                 : controller.genderController.text,
//           ),
//           items: const [
//             DropdownMenuItem(value: 'Male', child: Text('Male')),
//             DropdownMenuItem(value: 'Female', child: Text('Female')),
//             DropdownMenuItem(value: 'Other', child: Text('Other')),
//           ],
//           onChanged: (val) {
//             if (val != null) controller.selectedGender.value = val;
//           },
//         ),
//       ],
//     );
//   }
// }