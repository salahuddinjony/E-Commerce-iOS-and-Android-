import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/owner_nav/owner_nav.dart';

import '../../../../core/route_path.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = ['Pending', 'All Orders', 'Completed', 'Rejected'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final List<Map<String, String>> pendingOrders = [
    {
      'name': 'Geopart Etdsien',
      'parcelId': '#526365',
      'orderNumber': '562',
      'locationLine1': 'USA Nouth-2',
      'locationLine2': 'America',
      'imageUrl': 'https://i.pravatar.cc/150?img=3'
    },
    {
      'name': 'Geopart Etdsien',
      'parcelId': '#526365',
      'orderNumber': '562',
      'locationLine1': 'USA Nouth-2',
      'locationLine2': 'America',
      'imageUrl': 'https://i.pravatar.cc/150?img=3'
    },
  ];

  Widget _buildOrderCard(Map<String, String> order,VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(order['imageUrl']!),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      order['name']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),const Spacer(),
                    Text(
                      'Parcel ID:${order['parcelId']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text(
                      'Your Order Number:',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),const Spacer(),
                    Text(
                      order['orderNumber']!,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                Row(
                  children: [
                    Text(
                      order['locationLine1']!,
                      style: const TextStyle(color: Colors.grey),
                    ),const Spacer(),
                    GestureDetector(
                      onTap: onTap,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.teal[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Pending',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 15.h,),

              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildTabContent(String tab) {
    if (tab == 'Pending') {
      return ListView.builder(
        padding: const EdgeInsets.only(top: 16),
        itemCount: pendingOrders.length,
        itemBuilder: (context, index) {
          return _buildOrderCard(pendingOrders[index],(){
            context.pushNamed(
              RoutePath.pendingDetailsScreen,
            );
          });
        },
      );
    }
    // Placeholder for other tabs
    return Center(child: Text('No orders for $tab'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: const OwnerNav(currentIndex: 1),
      appBar: const CustomAppBar(
        appBarContent: AppStrings.order,
      ),
      body: Column(
        children: [
          // TabBar at the top
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.teal,
              unselectedLabelColor: Colors.black,
              indicatorColor: Colors.teal,
              tabs: _tabs.map((e) => Tab(text: e)).toList(),
            ),
          ),
          // TabBarView fills remaining space
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _tabs.map((tab) => _buildTabContent(tab)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
