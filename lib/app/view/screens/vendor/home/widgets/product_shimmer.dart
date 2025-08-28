import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductShimmer extends StatelessWidget {
  const ProductShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 119,
        child: ListView.builder(
          itemCount: 5,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 119,
                    width: 119,
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.image_not_supported,
                      size: 40,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              );
            },
        ),
      );
  }
}
