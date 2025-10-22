import 'package:flutter/material.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/view/common_widgets/profile_card/profile_card.dart';
import 'package:local/app/view/screens/features/client/user_home/vendor_list/model/nearest_vendor_response.dart';

class NearestVendorList extends StatelessWidget {
  final List<Vendor> vendorList;
  const NearestVendorList({super.key, required this.vendorList});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: vendorList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 5,
        crossAxisSpacing: 2,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        return ProfileCard(
          vendorItems: vendorList[index],
          imageUrl: vendorList[index].image ?? AppConstants.demoImage,
        );
      },
    );
  }
}
