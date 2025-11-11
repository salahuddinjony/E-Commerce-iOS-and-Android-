import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/custom_design_controller.dart';

class ProductColorPanel extends StatelessWidget {
  const ProductColorPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final CustomDesignController c = Get.find();
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose Your Product Color',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Obx(() {
              final selected = c.selectedProductColorIndex.value;
              final options = c.productColors;
              return LayoutBuilder(builder: (context, size) {
                final double maxWidth = size.maxWidth;
                final int crossAxisCount = maxWidth > 520 ? 8 : maxWidth > 420 ? 6 : 4;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: options.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.9,
                  ),
                  itemBuilder: (_, index) {
                    final option = options[index];
                    final isSelected = index == selected;
                    return GestureDetector(
                      onTap: () => c.selectProductColor(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? Colors.blueAccent : Colors.black26,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: option.swatch,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.black12),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              option.name,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.blueAccent : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              });
            }),
            const SizedBox(height: 18),
            Obx(() {
              final option = c.productColors[c.selectedProductColorIndex.value];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sizes available in ${option.name}:',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: option.sizes
                        .map((size) => Chip(
                              label: Text(size),
                              backgroundColor: Colors.grey[200],
                            ))
                        .toList(),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

