import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/view/screens/vendor/products_and_category/product/model/product_response.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../common_widgets/custom_network_image/custom_network_image.dart';
import '../../../../common_widgets/custom_text/custom_text.dart';

class StockAlert extends StatelessWidget {
  final List<ProductItem> productsList;

  StockAlert({
    super.key,
    required this.productsList,
  });

  List<ProductItem> get filteredProduct =>
      productsList.where((product) => product.quantity < 100).toList(); //here put the conditions for filter

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(filteredProduct.length, (index) {
          final product = filteredProduct[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomNetworkImage(
                    imageUrl: product.images.first.replaceFirst(
                      'http://10.10.20.19:5007',
                      'https://gmosley-uteehub-backend.onrender.com',
                    ),
                    height: 119,
                    width: 119),
                CustomText(
                  font: CustomFont.poppins,
                  color: AppColors.darkNaturalGray,
                  text: product.name,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                ),
                CustomText(
                  font: CustomFont.poppins,
                  color: AppColors.darkNaturalGray,
                  text: 'Price: \$22.20 ',
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                  bottom: 10.h,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
