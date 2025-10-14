import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';

import '../../../../../../core/route_path.dart';
import '../../../../../common_widgets/custom_button/custom_button.dart';

class OrderManegmentScreen extends StatelessWidget {
  const OrderManegmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define common text styles
    final titleStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
    final sectionTitleStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
    final bodyStyle = TextStyle(fontSize: 14, color: Colors.grey[700]);
    final bulletStyle = TextStyle(fontSize: 14, color: Colors.grey[700]);

    Widget buildBulletPoint(String text) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("• ", style: TextStyle(fontSize: 20)),
            Expanded(child: Text(text, style: bulletStyle)),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(iconData: Icons.arrow_back,),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Requirements – General Information for U TEE HUB',
              style: titleStyle,
            ),
            const SizedBox(height: 12),
            Text(
              'When placing an order on U TEE HUB, users need to provide specific details to ensure a smooth customization and delivery process. Below are the key order requirements:',
              style: bodyStyle,
            ),
            const SizedBox(height: 20),
            Text('Basic Order Details', style: sectionTitleStyle),
            const SizedBox(height: 10),
            buildBulletPoint(
                'T-Shirt Type – Select the fabric, fit, and style (e.g., cotton, oversized, slim fit).'),
            buildBulletPoint(
                'Size & Quantity – Choose the required sizes (S, M, L, XL, etc.) and the number of t-shirts.'),
            buildBulletPoint(
                'Color Preference – Pick from available color options for the t-shirt base.'),
            const SizedBox(height: 20),
            Text('Customization Details', style: sectionTitleStyle),
            const SizedBox(height: 10),
            buildBulletPoint(
                'Design Upload – Upload custom artwork, logos, or graphics.'),
            buildBulletPoint(
                'Text & Font Style – If adding text, specify the font, size, and placement.'),
            buildBulletPoint(
                'Print Position – Choose where the design should appear (front, back, sleeve).'),
            const SizedBox(height: 20),
            Text('Delivery & Shipping Information', style: sectionTitleStyle),
            const SizedBox(height: 10),
            buildBulletPoint(
                'Shipping Method – Select Home Delivery or Pickup from Seller’s Location.'),
            buildBulletPoint(
                'Address & Contact Details – Provide accurate location details for delivery.'),
            buildBulletPoint(
                'Processing Time – Estimated production and delivery time based on customization.'),

            SizedBox(
              height: 20.h,
            ),
            // CustomButton(
            //   onTap: () {
            //     context.pushNamed(RoutePath.helpCenterScreen);
            //   },
            //   title: "Contact Us",
            // )

          ],
        ),
      ),
    );
  }
}
