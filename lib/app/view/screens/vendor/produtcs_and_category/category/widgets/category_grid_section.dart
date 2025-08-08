import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/category_controller.dart';
import 'category_card.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/screens/vendor/produtcs_and_category/category/add_category/add_category.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryGridSection extends StatelessWidget {
  CategoryGridSection({super.key});
  final CategoryController categoryController = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
       
        SizedBox(height: 12.h),
        Expanded(
          child: Obx(() {
            final categories = categoryController.categoriesData;
            if (categories.isEmpty) {
              return const Center(child: Text('No Categories Found'));
            }
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
                childAspectRatio: 1.1,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return CategoryCard(category: categories[index]);
              },
            );
          }),
        ),
        SizedBox(height: 20.h),
         CustomButton(
          onTap: () {
           categoryController.fetchCategoires();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddCategory()),
            );
          },
          title: "Add Category",
          isRadius: true,
        ),
      ],
    );
  }
}
