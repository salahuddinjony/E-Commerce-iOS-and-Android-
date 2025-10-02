import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/core/route_path.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/product_details/controller/product_details_controller.dart';

class MakeAnOffer extends StatelessWidget {
  final controller;
  final String receiverImage;
  final String receiverName; // Replace with actual name
  final String userId; // Replace with actual user ID
  final String receiverId; // Replace with actual receiver ID
  const MakeAnOffer(
      {super.key,
      required this.controller,
      required this.receiverImage,
      required this.receiverName,
      required this.receiverId,
      required this.userId});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 14,
                offset: Offset(0, -6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // draggable indicator
              Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 14),

              // receiver info + title
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: receiverImage.isNotEmpty
                        ? NetworkImage(receiverImage) as ImageProvider
                        : null,
                    child: receiverImage.isEmpty
                        ? Text(
                            receiverName.isNotEmpty
                                ? receiverName[0].toUpperCase()
                                : '?',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Make an Offer',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        RichText(
                          text: TextSpan(
                            text: 'Send a proposal or discount to ',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                            children: [
                              TextSpan(
                                text: receiverName,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.brightCyan,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: Colors.grey.shade600),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // offer card mockup (tap to start flow)
              GestureDetector(
                onTap: () {
                  final customOrderController =
                      Get.put(ProductDetailsController(basePrice: 0));
                  context.pushNamed(
                    RoutePath.addAddressScreen,
                    extra: {
                      'vendorId': userId,
                      'receiverId': receiverId,
                      'controller': customOrderController,
                      'isCustomOrder': true,
                    },
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.brightCyan.withValues(alpha: .06),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.brightCyan.withValues(alpha: .12)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.brightCyan, Colors.blueAccent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Icon(Icons.local_offer,
                            color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Create new offer',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.grey.shade900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Add price, delivery time and message.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Colors.grey.shade500),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Close button (rounded)
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.grey.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    foregroundColor: Colors.black87,
                  ),
                  child: const Text('Close',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
