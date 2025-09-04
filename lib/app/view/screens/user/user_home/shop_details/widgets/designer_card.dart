import 'package:flutter/material.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_network_image/custom_network_image.dart';

class DesignerCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String subtitle;
  final double rating;
  final String reviews;
  final VoidCallback onTap;

  const DesignerCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.subtitle,
    required this.rating,
    required this.reviews,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: AppColors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CustomNetworkImage(
                  imageUrl: imageUrl,
                  width: 90,
                  height: 90,
                  boxShape: BoxShape.rectangle,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      '($subtitle)',
                      style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          'Rating:',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 6),
                        Icon(Icons.star, color: Colors.orange[400], size: 20),
                        Text(
                          rating.toString(),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: Text(
                        reviews,
                        style:
                            const TextStyle(color: Colors.blue, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}