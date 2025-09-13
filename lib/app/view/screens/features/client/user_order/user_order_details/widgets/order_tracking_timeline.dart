import 'package:flutter/material.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';

class OrderTrackingTimeline extends StatelessWidget {
  final List<String> statuses;
  final List<String>? dates;
  final int activeIndex;
  final bool isDisabled;

  const OrderTrackingTimeline({
    super.key,
    required this.statuses,
    this.dates,
    required this.activeIndex,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    const double outerSize = 48;
    const double midSize = 48;
    const double innerSize = 35;
    const double lineHeight = 2.5;
    const double nodeWidth = 120.0;
    const double connectorWidth = 56.0;

    return SizedBox(
      height: outerSize + 55,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: LayoutBuilder(builder: (context, constraints) {
          final count = statuses.length;
          final step = nodeWidth + connectorWidth;
          final contentWidth = (count * nodeWidth) + ((count - 1) * connectorWidth);
          final effectiveActive = activeIndex.clamp(0, count - 1);
          final Color activeColor = isDisabled ? Colors.grey : AppColors.brightCyan;
          final double rawOverlay = (effectiveActive * step) - (outerSize / 2);
          final double maxOverlay = (contentWidth - nodeWidth / 2);
          final double activeOverlayWidth = rawOverlay <= 0 ? 0.0 : rawOverlay.clamp(0.0, maxOverlay);

          return SizedBox(
            width: contentWidth,
            height: outerSize + 40,
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                Positioned(
                  left: nodeWidth / 2,
                  right: nodeWidth / 2,
                  top: outerSize / 2 - lineHeight / 2,
                  child: Container(height: lineHeight, color: Colors.grey[300]),
                ),
                Positioned(
                  left: nodeWidth / 2,
                  top: outerSize / 2 - lineHeight / 2,
                  width: activeOverlayWidth,
                  child: Container(height: lineHeight, color: activeColor),
                ),
                for (int i = 0; i < count; i++)
                  Positioned(
                    left: i * step,
                    top: 0,
                    child: SizedBox(
                      width: nodeWidth,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: outerSize,
                                height: outerSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                    color: i <= effectiveActive
                                        ? (statuses[i].toLowerCase().contains('cancel') ? Colors.red : activeColor).withOpacity(0.6)
                                        : Colors.grey.shade300,
                                    width: 2,
                                  ),
                                ),
                              ),
                              Container(
                                width: midSize,
                                height: midSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: i <= effectiveActive
                                      ? (statuses[i].toLowerCase().contains('cancel')
                                          ? Colors.red.withOpacity(0.12)
                                          : activeColor.withOpacity(0.12))
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: i <= effectiveActive
                                        ? (statuses[i].toLowerCase().contains('cancel') ? Colors.red : activeColor).withOpacity(0.35)
                                        : Colors.transparent,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              Container(
                                width: innerSize,
                                height: innerSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: i <= effectiveActive
                                      ? (statuses[i].toLowerCase().contains('cancel') ? Colors.red : activeColor)
                                      : Colors.white,
                                  border: Border.all(
                                    color: i <= effectiveActive
                                        ? (statuses[i].toLowerCase().contains('cancel') ? Colors.red : activeColor).withOpacity(0.9)
                                        : Colors.grey.shade300,
                                    width: 1.2,
                                  ),
                                ),
                                child: Center(
                                  child: i <= effectiveActive
                                      ? (statuses[i].toLowerCase().contains('cancel')
                                          ? const Icon(Icons.close, size: 16, color: Colors.white)
                                          : const Icon(Icons.check, size: 16, color: Colors.white))
                                      : Container(
                                          width: 6,
                                          height: 6,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[400],
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: nodeWidth,
                            child: Column(
                              children: [
                                Text(
                                  statuses[i],
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  style: TextStyle(
                                    color: i <= effectiveActive
                                        ? (statuses[i].toLowerCase().contains('cancel') ? Colors.red : activeColor)
                                        : Colors.grey,
                                    fontWeight: i == effectiveActive ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                if (dates != null && dates!.length > i)
                                  Text(
                                    dates![i],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}