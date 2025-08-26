import 'package:flutter/material.dart';
import 'package:local/app/global/helper/extension/extension.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';

class TransactionCard extends StatelessWidget {
  final String title;
  final String trxId;
  final String date;
  final String time;
  final String type;
  final String amount;
  final Color primaryColor;

  const TransactionCard({
    super.key,
    required this.title,
    required this.date,
    required this.time,
    required this.type,
    required this.amount,
    this.primaryColor = Colors.teal, required this.trxId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
             Row(
              children: [
                  Text(
                  title,
                  style: TextStyle(
                    color:type=='credit' ? AppColors.brightCyan :  Colors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Card(
                  elevation: 0.5,
                  color:type=='credit' ? Colors.green :  Colors.red ,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Text(
                      type.capitalizeFirstWord()+'ed',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),

              ],
             ),
                const SizedBox(height: 6),
                Text(
                  'TrxID: ${trxId}', 
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 13,
                  ),
                ),
                Text(
                  '$date ,$time',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                
              ],
            ),
            // Right side amount text
            Text(
              "${amount}\$",
                style: TextStyle(
                color: primaryColor.withValues(alpha: .7),
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
