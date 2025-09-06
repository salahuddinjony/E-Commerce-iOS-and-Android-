import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DesignFilesGallery extends StatelessWidget {
  final List<dynamic> files;

  const DesignFilesGallery({super.key, required this.files});

  @override
  Widget build(BuildContext context) {
    final list = files.cast<String>().where((e) => e.trim().isNotEmpty).toList();
    if (list.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Design Files', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final url = _normalize(list[index]);
                return GestureDetector(
                  onTap: () => _openPreview(context, list, index),
                  child: Hero(
                    tag: 'design_file_$index$url',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: url,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        placeholder: (c, _) => Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        errorWidget: (c, _, __) => Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey.shade300,
                          alignment: Alignment.center,
                          child: const Icon(Icons.broken_image, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _normalize(String file) {
    return file.replaceFirst(
      'http://10.10.20.19:5007',
      'https://gmosley-uteehub-backend.onrender.com',
    );
  }

  void _openPreview(BuildContext context, List<String> files, int initialIndex) {
    final controller = PageController(initialPage: initialIndex);
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => Stack(
        children: [
          PageView.builder(
            controller: controller,
            itemCount: files.length,
            itemBuilder: (c, i) {
              final url = _normalize(files[i]);
              return InteractiveViewer(
                minScale: 0.8,
                maxScale: 4,
                child: Center(
                  child: Hero(
                    tag: 'design_file_$i$url',
                    child: CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.contain,
                      placeholder: (c, _) => Shimmer.fromColors(
                        baseColor: Colors.grey.shade700,
                        highlightColor: Colors.grey.shade500,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade700,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      errorWidget: (c, _, __) => const Icon(
                        Icons.broken_image,
                        color: Colors.white70,
                        size: 80,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 28),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: controller,
              builder: (_, __) {
                int current = initialIndex;
                if (controller.hasClients && controller.page != null) {
                  current = controller.page!.floor();
                }
                final display = (current + 1).clamp(1, files.length);
                return Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$display / ${files.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}