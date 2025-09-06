import 'package:flutter/material.dart';
class DurationChip extends StatelessWidget {
  final String label;
  final IconData leading;
  const DurationChip({Key? key, required this.label, required this.leading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      color: WidgetStatePropertyAll(Colors.blue),
      label: Text(label, style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
      backgroundColor:
          Theme.of(context).colorScheme.primary.withValues(alpha: .1),
      labelStyle: Theme.of(context).textTheme.bodySmall,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      avatar: Icon(leading, size: 16.0, color: Colors.white),
    );
  }
}
