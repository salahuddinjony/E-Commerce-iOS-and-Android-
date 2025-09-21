import 'package:flutter/material.dart';
import 'package:local/app/view/common_widgets/custom_network_image/custom_network_image.dart';

class ChatHeader extends StatelessWidget implements PreferredSizeWidget {
  final String receiverName;
  final String receiverImage;
  final VoidCallback onBack;
  final VoidCallback? onMore;

  const ChatHeader({
    super.key,
    required this.receiverName,
    required this.receiverImage,
    required this.onBack,
    this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.white,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {},
              child: Stack(
                children: [
                  ClipOval(
                    child: CustomNetworkImage(
                        imageUrl: receiverImage, height: 48, width: 48),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    receiverName,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Active now',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onMore,
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: onBack,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);
}