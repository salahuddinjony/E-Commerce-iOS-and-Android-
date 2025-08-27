import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class StatussCard extends StatelessWidget {
  final String title;
  final String value;
  final Color tealColor;
  final IconData icon;
  final VoidCallback onTap;
  final bool loading;
  final String status;

  // Added optional fixed size controls
  final double cardWidth;
  final double cardHeight;

  const StatussCard({
  
    super.key,
    required this.title,
    required this.value,
    required this.tealColor,
    required this.icon,
    required this.onTap,
    this.cardWidth = 150, // tweak as needed
    this.cardHeight = 190, // tweak as needed
    required this.loading,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth.w,
        height: cardHeight.h,
        margin: EdgeInsets.only(right: 10.r),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: tealColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            const SizedBox(height: 8),
            loading
              ? Shimmer.fromColors(
                baseColor: Colors.white.withValues(alpha: .3),
                highlightColor: Colors.white,
                child: Container(
                  width: 50,
                  height: 20,
                  decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .4),
                  borderRadius: BorderRadius.circular(4),
                  ),
                ),
                )
              : Text(
                value.padLeft(2, '0'),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                ),
            const Spacer(), // Pushes button to bottom for uniform layout
            OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: const Size(0, 34),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('view order', style: TextStyle(color: Colors.white, fontSize: 12)),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, color: Colors.white, size: 14),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
