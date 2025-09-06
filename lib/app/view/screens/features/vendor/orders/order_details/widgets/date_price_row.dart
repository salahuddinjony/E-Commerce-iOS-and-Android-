import 'package:flutter/material.dart';

class DatePriceRow extends StatelessWidget {
  final String date;
  final String price;

  const DatePriceRow({
    super.key,
    required this.date,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(date, style: const TextStyle(fontWeight: FontWeight.w500)),
            Text(price, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}