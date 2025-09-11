import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/widgets/not_found.dart';
import '../widgets/extend_history_item.dart';

class ExtendHistoryScreen extends StatelessWidget {
  final String orderId;
  final List<dynamic> history;


  const ExtendHistoryScreen({
    Key? key,
    required this.orderId,
    required this.history,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // history expected reversed (latest first) as caller already reversed
    final entries = history;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        appBarContent: "Extension History",
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ID: $orderId',
              style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Extension Requests: ${history.length.toString().padLeft(2, '0')}',
              style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 12.h),
            Expanded(
              child: entries.isEmpty
                  ? LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minHeight: constraints.maxHeight),
                      child: Center(
                        child: NotFound(message: 'No extension history found.', icon: Icons.history)
                      ),
                    ),
                  ),
                )
                  : Stack(
                      children: [
                        // vertical track line
                        Positioned(
                          left: 28.w,
                          top: 0,
                          bottom: 0,
                          child: Container(
                            width: 2.w,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        ListView.separated(
                          itemCount: entries.length,
                          separatorBuilder: (_, __) => SizedBox(height: 18.h),
                          itemBuilder: (context, index) {
                            final item = entries[index];
                            final isLatest = index == 0;
                            return ExtendHistoryItem(
                              item: item,
                              isLatest: isLatest,
                            );
                          },
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
