// ...existing code...

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
// ...existing code...

import '../controller/custom_design_controller.dart';
import '../widgets/design_preview.dart';
import '../widgets/design_toolbar.dart';

class CustomDesignScreen extends StatelessWidget {
  const CustomDesignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // register controller for this screen so child widgets can use Get.find()
    final tag = ModalRoute.of(context)!.settings.name; // unique tag per screen instance
    final CustomDesignController c = Get.put(CustomDesignController(), tag: tag);

    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: true,
      appBar: const CustomAppBar(
        appBarContent: "Custom Design",
        iconData: Icons.arrow_back,
      ),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          final availableHeight = constraints.maxHeight;
          final previewHeight = (availableHeight * 0.55).clamp(180.0, availableHeight * 0.8);

          // Always scrollable. Use ConstrainedBox to ensure minimum height fills the viewport.
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisSize: MainAxisSize.min, // avoid expanding inside scroll
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  
                  const DesignToolbar(),
                  // show inline editor for active text box (if any)
             
                  const SizedBox(height: 12),
                  // upload controls
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        TextButton(
                          onPressed: c.pickImageFromGallery,
                          child: const Text("Upload Image", style: TextStyle(color: Colors.black)),
                        ),
                        Obx(() {
                          if (c.imagePath.value == null) {
                            return const SizedBox.shrink();
                          }
                          return TextButton.icon(
                            onPressed: c.isExporting.value
                                ? null
                                : () async {
                                    debugPrint('Download button tapped');
                                    final res = await c.savePreviewToGallery();
                                    debugPrint('savePreviewToGallery result: $res');
                                    debugPrint('exportedImageBytes length: ${c.exportedImageBytes.value?.lengthInBytes}');
                                    debugPrint('exportedImageBase64 length: ${c.exportedImageBase64.value?.length}');
                                    if (res['ok'] == true) {
                                      final path = res['path']?.toString() ?? '<unknown>';
                                      if (res['warning'] == 'permission_denied') {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saved to temp (permission denied): $path')));
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saved: $path')));
                                      }
                                    } else {
                                      final err = res['error']?.toString() ?? 'unknown';
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save: $err')));
                                    }
                                  },
                            icon: c.isExporting.value
                                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                                : const Icon(Icons.download),
                            label: const Text("Download", style: TextStyle(color: Colors.black)),
                          );
                        }),
                        Obx(() => c.imagePath.value != null
                            ? TextButton.icon(
                                onPressed: c.clearImage,
                                icon: const Icon(Icons.clear),
                                label: const Text("Clear"),
                              )
                            : const SizedBox.shrink()),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: previewHeight,
                    child: DesignPreview(),
                  ),
                  const SizedBox(height: 16),
                  // order button placed at bottom; it's not Expanded so it won't break scroll
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Obx(() => CustomButton(
                          onTap: c.isExporting.value
                              ? null
                              : () async {
                                  // prepare payload (exports and stores base64)
                                  final ok = await c.prepareOrderPayload();
                                  if (ok && c.exportedImageBase64.value != null) {
                                    // At this point, caller can post c.exportedImageBase64.value to API
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order payload ready')));
                                    // store or call API here. For now we just print to console.
                                    // print('base64 length: \'${c.exportedImageBase64.value!.length}\'');
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to prepare order')));
                                  }
                                },
                          title: c.isExporting.value ? 'Processing...' : 'Place Order',
                          height: 48,
                        )),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
