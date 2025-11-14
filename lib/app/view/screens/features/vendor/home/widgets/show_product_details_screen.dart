import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:local/app/global/helper/extension/extension.dart';
import 'package:local/app/view/screens/features/vendor/products_and_category/product/model/product_response.dart';

class ShowProductDetailsScreen extends StatelessWidget {
  final ProductItem product;
  const ShowProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
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
                        imageUrl: product.images.isNotEmpty
                            ? product.images.first.replaceFirst(
                                'http://10.10.20.19:5007',
                                'https://gmosley-uteehub-backend.onrender.com',
                              )
                            : '',
                        height: 160,
                        width: 160,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Container(
                          height: 160,
                          width: 160,
                          color: const Color(0xFF00BFCB).withValues(alpha: 0.15),
                          alignment: Alignment.center,
                          child: const Icon(Icons.broken_image,
                              color: Colors.grey, size: 40),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  infoRow('Name', product.name),
                  infoRow('Featured', product.isFeatured ? 'Yes' : 'No'),
                  infoRow('Price',
                      '${product.price.toString()} ${product.currency}'),
                  infoRow('Quantity', product.quantity.toString()),
                  infoRow('Created At', product.createdAt.formatDate()),
                  infoRow('Updated At', product.updatedAt.formatDate()),
                  const SizedBox(height: 10),
                  if (product.size.isNotEmpty) listRow('Sizes', product.size),
                  if (product.colors.isNotEmpty)
                    listRow('Colors', product.colors),
                  if (product.images.length > 1)
                    imagesRow('More Images', product.images),
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

  Widget listRow(String label, List<String> items) {
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
            child: Wrap(
              spacing: 6,
              runSpacing: 4,
              children: items.map((e) => Chip(label: Text(e))).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget imagesRow(String label, List<String> images) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label:',
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: Color(0xFF222B45))),
          const SizedBox(height: 6),
          SizedBox(
            height: 70,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (context, idx) => const SizedBox(width: 8),
              itemBuilder: (context, idx) => ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: images[idx].replaceFirst(
                    'http://10.10.20.19:5007',
                    'https://gmosley-uteehub-backend.onrender.com',
                  ),
                  height: 70,
                  width: 70,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Container(
                    height: 70,
                    width: 70,
                    color: const Color(0xFF00BFCB).withValues(alpha: .15),
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
