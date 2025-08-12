import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';

import '../../../../../core/route_path.dart';
import '../../../../../utils/custom_assets/assets.gen.dart';

class ShopDetailsScreen extends StatelessWidget {
  const ShopDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryLabels = [
      'Graphic Tees',
      'Dog Shirt',
      'Mans Tee',
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
              child: Assets.images.bacground.image(fit: BoxFit.cover)),
          // Dark overlay to make text readable
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.6),
            ),
          ),

          // Profile picture
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                AppConstants.demoImage,
              ),
            ),
          ),
          // Profile picture
          Positioned(
              top: 40,
              left: 0,
              right: 350,
              child: GestureDetector(
                onTap: () {
                  context.pop();
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back),
                ),
              )),

          // Name and location
          Positioned(
            top: 170,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  'Alex Carter',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  'Location: USA 256',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Content container (white background)
          Positioned(
            top: 250,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'TeeVibe Creations',
                      fontWeight: FontWeight.w700,
                      font: CustomFont.poppins,
                      color: AppColors.darkNaturalGray,
                      fontSize: 18.sp,
                    ),
                    CustomText(
                      textAlign: TextAlign.start,
                      maxLines: 10,
                      text:
                          'At TeeVibe Creations, we bring unique and stylish T-shirt designs to life. From trendy graphic tees to fully customizable options, we craft high-quality prints tailored to your style!',
                      fontWeight: FontWeight.w400,
                      font: CustomFont.poppins,
                      color: AppColors.naturalGray,
                      fontSize: 14.sp,
                    ),

                    SizedBox(height: 20.h),

                    CustomText(
                      text: 'Category',
                      fontWeight: FontWeight.w600,
                      font: CustomFont.poppins,
                      color: AppColors.brightCyan,
                      fontSize: 20.sp,
                    ),
                    SizedBox(height: 12.h),

                    // Categories horizontal list
                    SizedBox(
                      height: 100,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        separatorBuilder: (_, __) => SizedBox(width: 20.w),
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              CustomNetworkImage(
                                imageUrl: AppConstants.teeShirt,
                                height: 58,
                                width: 58,
                                boxShape: BoxShape.circle,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                categoryLabels[index],
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 12.h),

                    CustomText(
                      text: 'Popular T-Shirt Designs',
                      fontWeight: FontWeight.w600,
                      font: CustomFont.poppins,
                      color: AppColors.brightCyan,
                      fontSize: 20.sp,
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      height: 180, // height to fit the card + padding
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 4,
                        separatorBuilder: (_, __) => SizedBox(width: 12.w),
                        itemBuilder: (context, index) {
                          return SizedBox(
                            width: 140.w, // fixed card width
                            child: GestureDetector(
                              onTap: (){
                                context.pushNamed(
                                  RoutePath.productDetailsScreen,
                                );
                              },
                              child: Card(
                                color: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      ),
                                      child: Image.network(
                                        AppConstants.teeShirt,
                                        height: 110,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Nature Vibes',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            '100% Cotton',
                                            style: TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // You can add more content here if needed, like text below the image
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    CustomText(
                      text: 'Our Top Tee-Shirt Designer',
                      fontWeight: FontWeight.w600,
                      font: CustomFont.poppins,
                      color: AppColors.brightCyan,
                      fontSize: 20.sp,
                    ),
                    const SizedBox(height: 40),
                    DesignerCard(
                      imageUrl: 'https://i.pravatar.cc/150?img=2',
                      name: 'UrbanTee Lab',
                      subtitle: 'T-Shirt Designs',
                      rating: 4.4,
                      reviews: '1.5K+ reviews',
                      onTap: () {
                        context.pushNamed(
                          RoutePath.productDetailsScreen,
                        );
                      },
                    ),
                    const SizedBox(height: 12),

                    DesignerCard(
                      imageUrl: 'https://i.pravatar.cc/150?img=2',
                      name: 'UrbanTee Lab',
                      subtitle: 'T-Shirt Designs',
                      rating: 4.4,
                      reviews: '1.5K+ reviews',
                      onTap: () {  context.pushNamed(
                        RoutePath.productDetailsScreen,
                      );},
                    ),
                    const SizedBox(height: 12),
                    CustomText(
                      text: 'Shop Details',
                      fontWeight: FontWeight.w600,
                      font: CustomFont.poppins,
                      color: AppColors.darkNaturalGray,
                      fontSize: 18.sp,
                    ),

                    CustomText(
                      text: 'Products Available',
                      fontWeight: FontWeight.w500,
                      font: CustomFont.poppins,
                      color: AppColors.naturalGray,
                      fontSize: 16.sp,
                    ),
                    CustomText(
                      text: '150+ (T-Shirt Designs)',
                      fontWeight: FontWeight.w500,
                      font: CustomFont.poppins,
                      color: AppColors.naturalGray,
                      fontSize: 16.sp,
                    ),
                    CustomText(
                      text: 'Average Rating: ⭐4.8',
                      fontWeight: FontWeight.w500,
                      font: CustomFont.poppins,
                      color: AppColors.naturalGray,
                      fontSize: 16.sp,
                    ),

                    CustomText(
                      text: '2.5K+ reviews',
                      fontWeight: FontWeight.w500,
                      font: CustomFont.poppins,
                      color: AppColors.brightCyan,
                      fontSize: 16.sp,
                    ),
                    const SizedBox(height: 20),
                    CustomText(
                      text: 'Shipping Time',
                      fontWeight: FontWeight.w600,
                      font: CustomFont.poppins,
                      color: AppColors.darkNaturalGray,
                      fontSize: 18.sp,
                    ),
                    CustomText(
                      text: '(3-5 business days)',
                      fontWeight: FontWeight.w500,
                      font: CustomFont.poppins,
                      color: AppColors.naturalGray,
                      fontSize: 16.sp,
                    ),
                    CustomText(
                      text: ' 100% Cotton & Eco-Friendly Printing',
                      fontWeight: FontWeight.w500,
                      font: CustomFont.poppins,
                      color: AppColors.naturalGray,
                      fontSize: 16.sp,
                    ),
                    CustomText(
                      text: 'Custom Orders Available',
                      fontWeight: FontWeight.w500,
                      font: CustomFont.poppins,
                      color: AppColors.naturalGray,
                      fontSize: 16.sp,
                    ),
                    CustomText(
                      text: ' Best Seller on UTEE HUB',
                      fontWeight: FontWeight.w500,
                      font: CustomFont.poppins,
                      color: AppColors.naturalGray,
                      fontSize: 16.sp,
                    ),
                    const SizedBox(height: 40),
                    CustomButton(
                      onTap: () {
                        context.pushNamed(
                          RoutePath.customDesignScreen,
                        );
                      },
                      title: "Make A Custom",
                    ),
                    const SizedBox(height: 12),
                    CustomButton(
                      onTap: () {
                        context.pushNamed(
                          RoutePath.chatScreen,
                        );
                      },
                      title: "Chat",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DesignerCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String subtitle;
  final double rating;
  final String reviews;
  final VoidCallback onTap;

  const DesignerCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.subtitle,
    required this.rating,
    required this.reviews,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: AppColors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CustomNetworkImage(
                  imageUrl: imageUrl,
                  width: 90,
                  height: 90,
                  boxShape: BoxShape.rectangle,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      '($subtitle)',
                      style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          'Rating:',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 6),
                        Icon(Icons.star, color: Colors.orange[400], size: 20),
                        Text(
                          rating.toString(),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: Text(
                        reviews,
                        style:
                            const TextStyle(color: Colors.blue, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
