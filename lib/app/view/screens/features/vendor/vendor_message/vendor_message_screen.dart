// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';

// import '../../../../../core/route_path.dart';
// import '../../../../../utils/app_colors/app_colors.dart';
// import '../../../../../utils/app_constants/app_constants.dart';
// import '../../../../../utils/app_strings/app_strings.dart';
// import '../../../../common_widgets/custom_appbar/custom_appbar.dart';
// import '../../../../common_widgets/custom_text/custom_text.dart';
// import '../../../../common_widgets/message_card/message_card.dart';
// import '../../../../common_widgets/bottom_navigation_bar/vendor_nav/vendor_nav.dart';

// class VendorMessageScreen extends StatelessWidget {
// 	const VendorMessageScreen({super.key});

// 	@override
// 	Widget build(BuildContext context) {
// 		return  Scaffold(
// 			backgroundColor: AppColors.white,
// 			appBar: const CustomAppBar(
// 				appBarContent: AppStrings.chatList,
// 			),
// 			bottomNavigationBar:  OwnerNav(
// 				currentIndex:3 ,
// 			),
// 			body: Padding(
// 				padding: EdgeInsets.symmetric(horizontal: 24.w),
// 				child: Column(
// 					crossAxisAlignment: CrossAxisAlignment.start,
// 					children: [
// 						CustomText(
// 							text: 'All Message',
// 							font: CustomFont.inter,
// 							fontSize: 16.sp,
// 							fontWeight: FontWeight.w600,
// 							color: AppColors.darkNaturalGray,
// 						),
// 						SizedBox(
// 							height: 16.h,
// 						),
// 						Expanded(
// 							child: ListView.builder(
// 									itemCount: 4,
// 									itemBuilder: (context, index) {
// 										return // Reusable message card widget
// 											Padding(
// 												padding: EdgeInsets.only(top: 10.h),
// 												child: MessageCard(
// 													imageUrl: AppConstants.demoImage,
// 													senderName: 'Geopart Etdsien',
// 													message: 'Your Order Just Arrived!',
// 													onTap: () {
// 														debugPrint('object');
// 														context.pushNamed(
// 															RoutePath.chatScreen,
// 														);
// 													},
// 												),
// 											);
// 									}),
// 						)
// 					],
// 				),
// 			),
// 		);
// 	}
// }
