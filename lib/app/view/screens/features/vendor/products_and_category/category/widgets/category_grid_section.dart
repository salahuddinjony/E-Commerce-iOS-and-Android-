import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import '../controller/category_controller.dart';
import 'category_card.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/screens/features/vendor/products_and_category/category/add_category/add_category.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class CategoryGridSection extends StatelessWidget {
  CategoryGridSection({super.key});
  final CategoryController categoryController = Get.find<CategoryController>();

  Future<void> _refresh() async {
    await categoryController.refreshCategories();
  }

  Widget _shimmerGrid() {
    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.1,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8.r),
            ),
            margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
          ),
        );
      },
    );
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
              if (categoryController.isCategoryLoading.value) {
                return _shimmerGrid();
              }

              final categories = categoryController.categoriesData;
              final isPaginating = categoryController.isPaginating.value;
              
              if (categories.isEmpty) {
                return LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: Center(
                        child: Text(
                          "No Categories Found",
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
                controller: categoryController.scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
                  childAspectRatio: 1.1,
                ),
                itemCount: categories.length + (isPaginating ? 1 : 0),
                itemBuilder: (context, index) {
                  // Show loading indicator at the bottom when paginating
                  if (index == categories.length && isPaginating) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.w),
                        child: CircularProgressIndicator(
                          color: AppColors.brightCyan,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  }

                  return CategoryCard(category: categories[index]);
                },
              );
            }),
          ),
        ),
        SizedBox(height: 20.h),
        Obx(() => CustomButton(
              onTap: () {
                if (categoryController.isCategoryMutating.value) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddCategory(
                      imagePath: categoryController.imagePath.value,
                      categoryName: categoryController.nameController.text,
                      method: 'POST',
                      categoryId: null,
                    ),
                  ),
                );
              },
              title: categoryController.isCategoryMutating.value
                  ? "Please wait..."
                  : "Add Category",
              isRadius: true,
            )),
      ],
    );
  }
}
