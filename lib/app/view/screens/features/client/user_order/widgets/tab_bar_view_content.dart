// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

//   Widget buildMyOrdersList(BuildContext context, ) {
//     return Obx(() {
//       return ListView.separated(
//         itemCount: controller.myOrders.length,
//         separatorBuilder: (_, __) => SizedBox(height: 16.h),
//         itemBuilder: (context, index) {
//           final item = controller.myOrders[index];
//           return GestureDetector(
//             onTap: () {
//               context.pushNamed(
//                 RoutePath.userOrderDetailsScreen,
//               );
//             },
//             child: _OrderItemCard(
//               imagePath: item['image']!,
//               title: item['title']!,
//               subtitle: item['subtitle']!,
//               description: item['description']!,
//               isActive: item['isActive'] ?? false,
//             ),
//           );
//         },
//       );
//     });
//   }

//   Widget buildExtendRequestsList(BuildContext context) {
//     return Obx(() {
//       return ListView.separated(
//         itemCount: controller.extendDateRequests.length,
//         separatorBuilder: (_, __) => SizedBox(height: 16.h),
//         itemBuilder: (context, index) {
//           final item = controller.extendDateRequests[index];
//           return _ExtendRequestCard(
//             imagePath: item['image']!,
//             title: item['title']!,
//             subtitle: item['subtitle']!,
//             description: item['description']!,
//             requestedDays: item['requestedDays'] ?? 0,
//             isAccepted: item['isAccepted'] ?? false,
//             onAccept: item['isAccepted'] == false
//                 ? () {
//                     controller.acceptRequest(index);
//                     showCustomSnackBar(
//                       'You accepted a ${item['requestedDays']}-day extension for "${item['title']}".',
//                       isError: false,
//                       getXSnackBar: true,
//                     );
//                   }
//                 : null,
//           );
//         },
//       );
//     });
//   }
// }