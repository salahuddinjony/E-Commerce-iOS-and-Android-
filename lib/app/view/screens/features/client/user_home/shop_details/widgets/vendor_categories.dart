import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:local/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/widgets/customShimmer_loader.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/widgets/not_found.dart';
import 'package:local/app/view/screens/features/vendor/products_and_category/category/model/category_response.dart';

class VendorCategories extends StatelessWidget {
  final controller;
  const VendorCategories({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isCategoryLoading.value) {
        return CustomShimmerLoader(isCircleLoader: true);
      }
      final List<CategoryData> categoriesData = controller.categoriesData;
      if (categoriesData.isEmpty) {
        return NotFound(
            message: 'No categories available', icon: Icons.category_outlined);
      }
      return SizedBox(
        height: 100,
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 0.w),
          scrollDirection: Axis.horizontal,
          itemCount: categoriesData.length,
          separatorBuilder: (_, __) => SizedBox(width: 20.w),
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.green, width: 3),
                  ),
                  child: CustomNetworkImage(
                    imageUrl: categoriesData[index].image.replaceFirst(
                          'http://10.10.20.19:5007',
                          'https://gmosley-uteehub-backend.onrender.com',
                        ),
                    height: 58,
                    width: 58,
                    boxShape: BoxShape.circle,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  categoriesData[index].name,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            );
          },
        ),
      );
    });
  }
}
