import 'package:flutter/material.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';

class TransactionCard extends StatelessWidget {
  final String title;
  final String date;
  final String time;
  final String relativeTime;
  final String amount;
  final Color primaryColor;

  const TransactionCard({
    super.key,
    required this.title,
    required this.date,
    required this.time,
    required this.relativeTime,
    required this.amount,
    this.primaryColor = Colors.teal,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: primaryColor.withOpacity(0.7),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$date ,$time',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  relativeTime,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            // Right side amount text
            Text(
              amount,
              style: TextStyle(
                color: primaryColor.withOpacity(0.7),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
