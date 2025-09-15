import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/controller/shop_details_controller.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/widgets/name_and_location.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/widgets/shop_details_content.dart';
import '../../../../../../../utils/custom_assets/assets.gen.dart';

class ShopDetailsScreen extends StatelessWidget {
  final String imageUrl;
  final String shopLocation;
  final String shopName;
  final String vendorId;

  ShopDetailsScreen({
    super.key,
    this.imageUrl = '',
    this.shopLocation = '',
    this.shopName = '',
    this.vendorId = '',
  });
  final ShopDetailsController controller = Get.find<ShopDetailsController>();

  @override
  Widget build(BuildContext context) {
    // final displayImage =imageUrl.isNotEmpty ? imageUrl : AppConstants.demoImage;
    final displayName = shopName.isNotEmpty ? shopName : 'Alex Carter';

    final displayLocation =
        shopLocation.isNotEmpty ? shopLocation.split(',').last : 'USA 256';
    // final displayVendorId = vendorId.isNotEmpty ? vendorId : 'Vendor ID';

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
              child: Assets.images.bacground.image(fit: BoxFit.cover)),

          // Dark overlay to make text readable
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: .6),
            ),
          ),

          // Profile picture
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: CircleAvatar(
                  radius: 48,
                  backgroundImage: NetworkImage(AppConstants.demoImage),
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
          ),
          // Back button
          Positioned(
            top: 40,
            left: 0,
            right: 350,
            child: GestureDetector(
              onTap: () {
                context.pop();
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back),
              ),
            ),
          ),

          // Name and location
          NameAndLocation(
              displayLocation: displayLocation, displayName: displayName),

          // Content container (white background)
          ShopDetailsContent(
            controller: controller,
            vendorId: vendorId,
            role: 'vendor',
            vendorName: displayName,
            imageUrl: imageUrl,
          ),
        ],
      ),
    );
  }
}
