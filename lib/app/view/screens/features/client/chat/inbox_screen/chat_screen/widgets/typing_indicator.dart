import 'package:flutter/material.dart';

class TypingIndicator extends StatelessWidget {
  final bool visible;
  const TypingIndicator({super.key, required this.visible});

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: const [
          SizedBox(width: 8),
          Text(
            'Typing...',
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}