import 'package:flutter/material.dart';

class ImagePickerOption<T> extends StatelessWidget {
  final T controller;
  final Future<void> Function(T controller, String source) onPickImage;
  final ScrollController scrollController;

  const ImagePickerOption({
    super.key,
    required this.controller,
    required this.onPickImage,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: ListView(
        shrinkWrap: true,
        controller: scrollController,
        children: [
          Center(
            child: Container(
              height: 5,
              width: 50,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt, color: Colors.cyan, size: 28),
            title: const Text("Take Photo", style: TextStyle(fontSize: 16)),
            onTap: () async {
              await onPickImage(controller, 'camera');
              Navigator.pop(context);
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading:
                const Icon(Icons.photo_library, color: Colors.cyan, size: 28),
            title: const Text("Choose from Gallery",
                style: TextStyle(fontSize: 16)),
            onTap: () async {
              await onPickImage(controller, "gallery");
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
