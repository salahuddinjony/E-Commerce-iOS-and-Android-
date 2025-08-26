import 'package:flutter/material.dart';

class EmptyStateScrollable extends StatelessWidget {
  final String message;
  final IconData icon;
  final double topPadding;
  final double minHeightOffset;
  final Color? iconColor;

  const EmptyStateScrollable({
    super.key,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.topPadding = 80,
    this.minHeightOffset = 120,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(top: topPadding),
            // Ensures RefreshIndicator can trigger when empty
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - minHeightOffset,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 48,
                    color: iconColor ?? Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}