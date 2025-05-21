import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:local/app/view/common_widgets/nav_bar/nav_bar.dart';

class UserOrderScreen extends StatefulWidget {
  UserOrderScreen({super.key});

  @override
  State<UserOrderScreen> createState() => _UserOrderScreenState();
}

class _UserOrderScreenState extends State<UserOrderScreen> {
  final List<Map<String, dynamic>> _myOrders = [
    {
      'image': AppConstants.demoImage,
      'title': 'Guitar Soul Tee',
      'subtitle': 'Supreme Soft Cotton',
      'description':
      'These T-shirts are popular for their unique design and high-quality fabric. Pick your favorite now!',
      'isActive': true,
    },
    {
      'image': AppConstants.demoImage,
      'title': 'Vintage Rock Tee',
      'subtitle': 'Classic Cotton',
      'description': 'A classic vintage rock tee, a must-have for all rock fans.',
      'isActive': false,
    },
  ];

  // Extension request list with requestedDays and isAccepted flags
  List<Map<String, dynamic>> _extendDateRequests = [
    {
      'image': AppConstants.demoImage,
      'title': 'Extended Guitar Soul Tee',
      'subtitle': 'Extended Soft Cotton',
      'description': 'Extension request sent for this order.',
      'requestedDays': 5,
      'isAccepted': false,
    },
    {
      'image': AppConstants.demoImage,
      'title': 'Extended Rock Tee',
      'subtitle': 'Extended Soft Cotton',
      'description': 'Extension date request.',
      'requestedDays': 3,
      'isAccepted': false,
    },
  ];

  void _acceptRequest(int index) {
    setState(() {
      _extendDateRequests[index]['isAccepted'] = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'You accepted a ${_extendDateRequests[index]['requestedDays']}-day extension for "${_extendDateRequests[index]['title']}".',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: const CustomAppBar(
          appBarContent: "Order",
        ),
        bottomNavigationBar: const CustomNavBar(currentIndex: 1),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabBar(
                indicatorColor: Colors.blue,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                labelStyle:
                TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp),
                tabs: const [
                  Tab(text: 'My Orders'),
                  Tab(text: 'Date Extension Requests'),
                ],
              ),
              SizedBox(height: 12.h),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildMyOrdersList(),
                    _buildExtendRequestsList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMyOrdersList() {
    return ListView.separated(
      itemCount: _myOrders.length,
      separatorBuilder: (_, __) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        final item = _myOrders[index];
        return _OrderItemCard(
          imagePath: item['image']!,
          title: item['title']!,
          subtitle: item['subtitle']!,
          description: item['description']!,
          isActive: item['isActive'] ?? false,
        );
      },
    );
  }

  Widget _buildExtendRequestsList() {
    return ListView.separated(
      itemCount: _extendDateRequests.length,
      separatorBuilder: (_, __) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        final item = _extendDateRequests[index];
        return _ExtendRequestCard(
          imagePath: item['image']!,
          title: item['title']!,
          subtitle: item['subtitle']!,
          description: item['description']!,
          requestedDays: item['requestedDays'] ?? 0,
          isAccepted: item['isAccepted'] ?? false,
          onAccept: item['isAccepted'] == false
              ? () => _acceptRequest(index)
              : null,
        );
      },
    );
  }
}

class _OrderItemCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final String description;
  final bool isActive;

  const _OrderItemCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.description,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyleTitle = TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 16.sp,
      color: Colors.black,
    );

    final textStyleSubtitle = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12.sp,
      color: Colors.grey[600],
    );

    final textStyleDescription = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12.sp,
      color: Colors.grey[700],
      height: 1.3,
    );

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomNetworkImage(
            imageUrl: imagePath,
            height: 127,
            width: 119,
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: textStyleTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isActive) ...[
                      SizedBox(width: 8.w),
                      Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          'Active',
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 2.h),
                Text(subtitle, style: textStyleSubtitle),
                SizedBox(height: 6.h),
                RichText(
                  text: TextSpan(
                    style: textStyleDescription,
                    children: [
                      const TextSpan(text: 'These '),
                      TextSpan(
                        text: 'T-shirts',
                        style: const TextStyle(color: Colors.blue),
                      ),
                      const TextSpan(
                        text:
                        ' are popular for their unique design and quality fabric. Pick your favorite now!',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExtendRequestCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final String description;
  final int requestedDays;
  final bool isAccepted;
  final VoidCallback? onAccept;

  const _ExtendRequestCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.requestedDays,
    required this.isAccepted,
    this.onAccept,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyleTitle = TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 16.sp,
      color: Colors.black,
    );

    final textStyleSubtitle = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12.sp,
      color: Colors.grey[600],
    );

    final textStyleDescription = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12.sp,
      color: Colors.grey[700],
      height: 1.3,
    );

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomNetworkImage(
            imageUrl: imagePath,
            height: 127,
            width: 119,
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: textStyleTitle),
                SizedBox(height: 2.h),
                Text(subtitle, style: textStyleSubtitle),
                SizedBox(height: 6.h),
                Text(description, style: textStyleDescription),
                SizedBox(height: 12.h),
                if (!isAccepted)
                  ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 10.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Accept',
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w600),
                    ),
                  ),
                if (isAccepted)
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      'You accepted a $requestedDays-day extension',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
