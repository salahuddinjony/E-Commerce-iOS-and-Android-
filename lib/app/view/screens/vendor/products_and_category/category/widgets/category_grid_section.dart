import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import '../controller/category_controller.dart';
import 'category_card.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/screens/vendor/products_and_category/category/add_category/add_category.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryGridSection extends StatelessWidget {
  CategoryGridSection({super.key});
  final CategoryController categoryController = Get.find<CategoryController>();
  Future<void> _refresh() async {
    await categoryController.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 12.h),
        Expanded(
          child: RefreshIndicator(
            backgroundColor: Colors.white,
            color: AppColors.brightCyan,
            onRefresh: _refresh,
            child: Obx(() {
              final categories = categoryController.categoriesData;
              if (categories.isEmpty) {
                // Allow pull-to-refresh even when empty
                return LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: Center(
                        child: Text(
                          "No Products Found",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
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
        ),
        SizedBox(height: 20.h),
        CustomButton(
          onTap: () {
            // categoryController.fetchCategories();
           print("Add Category Clicked");
           print("categorydata lenght: ${categoryController.categoriesData.length}");
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddCategory(
                        imagePath: categoryController.imagePath.value,
                        categoryName: categoryController.nameController.text,
                        method: 'POST',
                        categoryId: null,
                      )),
            );
            // AppRouter.route.goNamed(
            //   RoutePath.addCategory,
            //   queryParameters: {
            //     "imagePath": categoryController.imagePath.value,
            //     "categoryName": categoryController.nameController.text,
            //   },
            // );
          },
          title: "Add Category",
          isRadius: true,
        ),
      ],
    );
  }
}
