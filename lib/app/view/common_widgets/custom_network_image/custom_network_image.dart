import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final Border? border;
  final BorderRadius? borderRadius;
  final BoxShape boxShape;
  final Color? backgroundColor;
  final Widget? child;
  final ColorFilter? colorFilter;

  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    required this.height,
    required this.width,
    this.child,
    this.colorFilter,
    this.backgroundColor,
    this.border,
    this.borderRadius,
    this.boxShape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    // Fix any backslashes and remove square brackets from the image URL
    String fixedImageUrl = imageUrl.replaceAll('\\', '/');
    
    // Remove square brackets if they exist (common when URLs are stored as lists)
    if (fixedImageUrl.startsWith('[') && fixedImageUrl.endsWith(']')) {
      fixedImageUrl = fixedImageUrl.substring(1, fixedImageUrl.length - 1);
    }
    
    // Additional safety check: ensure the URL is not empty and is valid
    if (fixedImageUrl.isEmpty || !fixedImageUrl.startsWith('http')) {
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          border: border,
          color: backgroundColor ?? Colors.grey[300],
          borderRadius: borderRadius,
          shape: boxShape,
        ),
        child: const Icon(Icons.image_not_supported, color: Colors.grey),
      );
    }
    
    return CachedNetworkImage(
      imageUrl: fixedImageUrl,
      imageBuilder: (context, imageProvider) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          border: border,
          borderRadius: borderRadius,
          shape: boxShape,
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.contain,
            colorFilter: colorFilter,
          ),
        ),
        child: child,
      ),
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey.withValues(alpha: .6),
        highlightColor: Colors.grey.withValues(alpha: .3),
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            border: border,
            color: backgroundColor , // Default to white for placeholder
            borderRadius: borderRadius,
            shape: boxShape,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          border: border,
          color: backgroundColor , // Red for error
          borderRadius: borderRadius,
          shape: boxShape,
        ),
        child: const Icon(Icons.error),
      ),
    );
  }
}
