import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        appBarContent: "About U Tee Hub",
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 20.h),
        // Padding around the content
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Section
              CustomText(
                textAlign: TextAlign.start,
                text:
                    "Welcome to T-Shirt Hub – Your Ultimate Destination for Trendy & Comfortable T-Shirts!",
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
                font: CustomFont.poppins,
                color: AppColors.black,
                maxLines: 3,
              ),
              SizedBox(height: 8.h), // Spacing between sections

              CustomText(
                textAlign: TextAlign.start,
                text:
                    "At T-Shirt Hub, we believe that fashion is a form of self-expression. Our mission is to provide high-quality, stylish, and comfortable t-shirts that let you showcase your personality, passions, and creativity. Whether you’re looking for casual wear, custom designs, or premium quality fabrics, we’ve got you covered!",
                fontWeight: FontWeight.w400,
                fontSize: 12.sp,
                font: CustomFont.poppins,
                color: AppColors.naturalGray,
                maxLines: 10,
              ),
              SizedBox(height: 30.h),
              CustomText(
                textAlign: TextAlign.start,
                text: "Our Story",
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
                font: CustomFont.poppins,
                color: AppColors.black,
                maxLines: 3,
              ),
              SizedBox(height: 10.h),
              CustomText(
                textAlign: TextAlign.start,
                text:
                    "T-Shirt Hub started with a simple idea: to revolutionize the way people shop for t-shirts. We noticed that finding the perfect t-shirt—one that fits well, feels comfortable, and looks great—was often a challenge. That’s why we set out to create a platform where customers can browse a wide variety of t-shirts, from classic solid colors to trendy graphic prints, at the best prices. Our journey began with a small team of passionate designers and entrepreneurs who shared a love for fashion and quality craftsmanship. Over time, we expanded our offerings, built strong relationships with top manufacturers, and developed a seamless online shopping experience that makes finding the perfect t-shirt easy and enjoyable.",
                fontWeight: FontWeight.w400,
                fontSize: 12.sp,
                font: CustomFont.poppins,
                color: AppColors.naturalGray,
                maxLines: 20,
              ),
              SizedBox(height: 30.h),

              CustomText(
                textAlign: TextAlign.start,
                text: "Why Choose U TEE Hub?",
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
                font: CustomFont.poppins,
                color: AppColors.black,
                maxLines: 3,
              ),
              Column(
                children: [
                  _buildFeatureRow("1. Wide Range of Styles"),
                  _buildFeatureRow("2. Solid T-Shirts – Classic and Versatile"),
                  _buildFeatureRow("3. Graphic Tees – Trendy and Expressive"),
                  _buildFeatureRow(
                      "4. Full Sleeve T-Shirts – Stylish and Cozy"),
                  _buildFeatureRow(
                      "5. Oversized T-Shirts – Relaxed and Fashionable"),
                  _buildFeatureRow("6. Premium Cotton Tees – Soft and Durable"),
                  _buildFeatureRow(
                      "7. Customized T-Shirts – Create Your Own Design"),
                ],
              ),
              SizedBox(height: 30.h),

              CustomText(
                textAlign: TextAlign.start,
                text: "Customer Support ?",
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
                font: CustomFont.poppins,
                color: AppColors.black,
                maxLines: 3,
              ),

              CustomText(
                textAlign: TextAlign.start,
                text: "📧 Email: support@tshirthub.com ",
                fontWeight: FontWeight.w400,
                fontSize: 12.sp,
                font: CustomFont.poppins,
                color: AppColors.black,
                maxLines: 3,
              ),
              CustomText(
                textAlign: TextAlign.start,
                text: "📞 Call: +1-800-555-TSHIRT",
                fontWeight: FontWeight.w400,
                fontSize: 12.sp,
                font: CustomFont.poppins,
                color: AppColors.black,
                maxLines: 3,
              ),

              CustomText(
                textAlign: TextAlign.start,
                text: "Thank you for choosing U TEE HUB – where fashion meets comfort!",
                fontWeight: FontWeight.w400,
                fontSize: 12.sp,
                font: CustomFont.poppins,
                color: AppColors.black,
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(String text) {
    return Row(
      children: [
        SizedBox(width: 10.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
