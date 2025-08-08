import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/utils/custom_assets/assets.gen.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/common_widgets/custom_from_card/custom_from_card.dart';
import 'package:local/app/view/common_widgets/custom_text_field/custom_text_field.dart';
import '../../../../../../utils/app_colors/app_colors.dart';
import '../../../../../common_widgets/custom_appbar/custom_appbar.dart';
import '../../../../../common_widgets/custom_text/custom_text.dart';

class AddProductScreen extends StatefulWidget {
  // final Product product;
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController categoryController = TextEditingController();
  bool isDropdownOpen = false;

  final List<String> categoryOptions = [
    "Female T shirt",
    "Male T shirt",
    "Kids T shirt",
    "Accessories",
    "Hoodies",
  ];

  void toggleDropdown() {
    setState(() {
      isDropdownOpen = !isDropdownOpen;
    });
  }

  void selectCategory(String category) {
    setState(() {
      categoryController.text = category;
      isDropdownOpen = false;
    });
  }

  @override
  void dispose() {
    categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        iconData: Icons.arrow_back,
        appBarContent: "Add Product",
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h),
                  decoration: BoxDecoration(
                      color: AppColors.white1,
                      borderRadius: BorderRadius.all(Radius.circular(12.r))),
                  child: Column(
                    children: [
                      Assets.images.upload.image(),
                      CustomText(
                        font: CustomFont.poppins,
                        color: AppColors.darkNaturalGray,
                        text: 'Upload Image',
                        fontWeight: FontWeight.w500,
                        fontSize: 18.sp,
                        bottom: 8.h,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              CustomFromCard(
                hinText: "U Tee Hub",
                title: "Product Name",
                controller: TextEditingController(),
                validator: (v) {},
              ),
              CustomText(
                font: CustomFont.inter,
                color: AppColors.darkNaturalGray,
                text: 'Category',
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                bottom: 8.h,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    inputTextStyle: const TextStyle(color: AppColors.black),
                    textEditingController: categoryController,
                    validator: (v) {},
                    readOnly: true,
                    suffixIcon: GestureDetector(
                      onTap: toggleDropdown,
                      child: Icon(
                        isDropdownOpen
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        size: 28,
                        color: Colors.black54,
                      ),
                    ),
                  ),

                  // Dropdown menu shown below the text field (no Stack needed)
                  if (isDropdownOpen)
                    Container(
                      margin: EdgeInsets.only(top: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: categoryOptions.length,
                        separatorBuilder: (_, __) =>
                            Divider(height: 1, color: Colors.grey.shade300),
                        itemBuilder: (context, index) {
                          final item = categoryOptions[index];
                          return ListTile(
                            title: Text(item),
                            onTap: () => selectCategory(item),
                          );
                        },
                      ),
                    ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              CustomFromCard(
                hinText: "S,M,L,XL,XXL",
                title: "Sizes Available",
                controller: TextEditingController(),
                validator: (v) {},
              ),
              CustomFromCard(
                hinText: "20\$",
                title: " Price (\$)",
                controller: TextEditingController(),
                validator: (v) {},
              ),
              CustomFromCard(
                hinText: "U Tee Hub",
                title: "Product Name",
                controller: TextEditingController(),
                validator: (v) {},
              ),
              CustomFromCard(
                hinText: "Yes/No",
                title: " Customizable",
                controller: TextEditingController(),
                validator: (v) {},
              ),
              SizedBox(
                height: 50.h,
              ),
              CustomButton(
                title: "Submit",
                onTap: () {
                  context.pop();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
