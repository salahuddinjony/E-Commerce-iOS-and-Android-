import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:local/app/global/helper/extension/extension.dart';
import 'package:local/app/view/screens/features/vendor/products_and_category/category/model/category_response.dart';

class ShowCategoryDetailsScreen extends StatelessWidget {
  final CategoryData category;
  const ShowCategoryDetailsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category Details'),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      backgroundColor: const Color(0xFFF7F8FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Center(
          child: Card(
            color: Colors.white,
            elevation: 0.5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: CachedNetworkImage(
                        imageUrl: category.image.replaceFirst(
                          'http://10.10.20.19:5007',
                          'https://gmosley-uteehub-backend.onrender.com',
                        ),
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Container(
                          height: 200,
                          width: 200,
                          color: const Color(0xFF00BFCB).withValues(alpha: 0.15),
                          alignment: Alignment.center,
                          child: const Icon(Icons.broken_image,
                              color: Colors.grey, size: 40),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  infoRow('Name', category.name),
                  if (category.createdAt.isNotEmpty)
                    infoRow('Created At', _formatDate(category.createdAt)),
                  if (category.updatedAt.isNotEmpty)
                    infoRow('Updated At', _formatDate(category.updatedAt)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: Color(0xFF222B45)),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                  fontWeight: FontWeight.w400, color: Color(0xFF222B45)),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return date.formatDate();
    } catch (e) {
      return dateString;
    }
  }
}

