import 'package:flutter/material.dart';
import '../widgets/count_down_box.dart';
import '../controller/view_order_details_controller.dart';

class CountdownRow extends StatelessWidget {
  final Duration remaining;
  final ViewOrderDetailsController controller;
  const CountdownRow(
      {super.key, required this.remaining, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: CountdownBox(
              number: controller.twoDigits(remaining.inDays), label: 'Days'),
        ),
        SizedBox(width: 6),
        Expanded(
          child: CountdownBox(
              number: controller.twoDigits(remaining.inHours % 24),
              label: 'Hours'),
        ),
        SizedBox(width: 6),
        Expanded(
          child: CountdownBox(
              number: controller.twoDigits(remaining.inMinutes % 60),
              label: 'Min'),
        ),
        SizedBox(width: 6),
        Expanded(
          child: CountdownBox(
              number: controller.twoDigits(remaining.inSeconds % 60),
              label: 'Sec'),
        ),
      ],
    );
  }
}
