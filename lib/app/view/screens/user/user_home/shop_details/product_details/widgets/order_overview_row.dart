import 'package:flutter/material.dart';

class OrderOverviewRow extends StatelessWidget {
  final String fieldName;
  final String fieldValue;
  final bool isTrue;
  const OrderOverviewRow(
      {super.key,
      required this.fieldName,
      required this.fieldValue,
      required this.isTrue});

  @override
  Widget build(BuildContext context) {
    return isTrue
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                fieldName,
                style: TextStyle(fontSize: 15, color: Colors.black87),
              ),
              Text(
                fieldValue,
                style: TextStyle(fontSize: 15, color: Colors.black87),
              )
            ],
          )
        : SizedBox.shrink();
  }
}
