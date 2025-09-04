import 'package:flutter/material.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/view/common_widgets/profile_card/profile_card.dart';
import 'package:local/app/view/screens/user/user_home/vendor_list/model/nearest_vendor_response.dart';

class NearestVendorList extends StatelessWidget {
  final List<UserItem> vendorList;
  const NearestVendorList({super.key, required this.vendorList});

  @override
  Widget build(BuildContext context) {
    final filteredVendorList =
        vendorList.where((vendor) => vendor.status == 'active').toList();
    if (filteredVendorList.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.store_mall_directory, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text('No vendors available'),
          ],
        ),
      );
    }
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: filteredVendorList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 5,
        crossAxisSpacing: 2,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        return ProfileCard(
          vendorItems: filteredVendorList[index],
          imageUrl: AppConstants.demoImage,
        );
      },
    );
  }
}
