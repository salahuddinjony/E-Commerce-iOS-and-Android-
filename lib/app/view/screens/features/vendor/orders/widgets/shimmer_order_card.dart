import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerOrderCard extends StatelessWidget {
  const ShimmerOrderCard({
    super.key,
    this.shimmerWholeCard = false,
  });

  final bool shimmerWholeCard;

  Color get baseColor => Colors.grey[300]!;
  Color get highlightColor => Colors.grey[100]!;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final double maxW = constraints.maxWidth == double.infinity
            ? MediaQuery.of(context).size.width - 32 /* page padding */
            : constraints.maxWidth;

        // Responsive widths (clamped)
        double w(double fraction, {double min = 60, double max = 260}) {
          return (maxW * fraction).clamp(min, max);
        }

        final content = Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              rowLine(leftW: w(.42), rightW: w(.18)),
              const SizedBox(height: 20),
              rowLine(leftW: w(.50), rightW: w(.20)),
              const SizedBox(height: 20),
              rowLine(leftW: w(.35), rightW: w(.22)),
              const SizedBox(height: 20),
                Center(
                child: pill(h: 28, w: w(.55)),
                ),
              const SizedBox(height: 16),
              rect(h: 48, w: double.infinity, radius: 8),
            ],
          ),
        );

        Widget card = Card(
          elevation: 0.5,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: content,
        );

        if (shimmerWholeCard) {
          card = Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: card,
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: card,
        );
      },
    );
  }

  Widget rowLine({required double leftW, required double rightW}) {
    return Row(
      children: [
        rect(h: 16, w: leftW),
        const Spacer(),
        pill(h: 24, w: rightW),
      ],
    );
  }

  // Individual shimmer only when whole-card shimmer is OFF
  Widget pill({required double h, required double w}) {
    final child = Container(
      height: h,
      width: w,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(h / 2),
      ),
    );
    if (shimmerWholeCard) return child;
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: child,
    );
  }

  Widget rect({
    required double h,
    required double w,
    double radius = 6,
  }) {
    final child = Container(
      height: h,
      width: w,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
    if (shimmerWholeCard) return child;
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: child,
    );
  }
}
