import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/screens/user/user_home/shop_details/product_details/product_details_controller.dart';

Widget counterButton(
    {required String label,
    required int quantity,
    required VoidCallback onPressed,
    required String tag}) {
  late final ProductDetailsController controller =
      Get.isRegistered<ProductDetailsController>(tag: tag)
          ? Get.find<ProductDetailsController>(tag: tag)
          : Get.put(ProductDetailsController(), tag: tag);
  return SizedBox(
    width: 36,
    height: 36,
    child:Obx(() => ElevatedButton(
              onPressed: (label == '-' && controller.items.value == 1)
                  ? null
                  : (label == '+' && controller.items.value >= quantity ? null : onPressed),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                foregroundColor: Colors.deepOrange,
                backgroundColor: AppColors.white,
              ),
              child: Text(label, style: const TextStyle(fontSize: 22)),
            )),
       
  );
}

Widget thumbnail(String url) {
  return Container(
    margin: const EdgeInsets.only(right: 10),
    width: 60,
    height: 60,
    decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover)),
  );
}
