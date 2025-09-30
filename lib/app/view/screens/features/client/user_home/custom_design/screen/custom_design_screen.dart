import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:go_router/go_router.dart';
// import 'package:local/app/core/route_path.dart';
// import 'package:local/app/global/helper/toast_message/toast_message.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
// import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
// import 'package:local/app/view/screens/features/client/user_home/shop_details/product_details/controller/product_details_controller.dart';
import '../controller/custom_design_controller.dart';
import '../widgets/design_preview.dart';
import '../widgets/design_toolbar.dart';

class OrderFormController {
  final customerNameController = TextEditingController();
  final customerPhoneController = TextEditingController();
  final customerRegionCityController = TextEditingController();
  final customerAddressController = TextEditingController();

  // fields used by CustomOrderField when isCustomOrder=true
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final deliveryOptionController = TextEditingController();
  final deliveryDate = TextEditingController();
  final summeryController = TextEditingController();

  bool checkCustomerInfoIsEmpty() {
    return customerNameController.text.trim().isEmpty ||
        customerPhoneController.text.trim().isEmpty;
  }
}

class CustomDesignScreen extends StatelessWidget {
  final String vendorId;
  final bool isFromCustomHub;

  const CustomDesignScreen(
      {super.key, required this.vendorId, this.isFromCustomHub = false});

  @override
  Widget build(BuildContext context) {
    debugPrint('CustomDesignScreen for vendorId: $vendorId');
    // register controller for this screen so child widgets can use Get.find()
    final CustomDesignController c = Get.put(CustomDesignController());

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
          final previewHeight =
              (availableHeight * 0.55).clamp(180.0, availableHeight * 0.8);

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
                          child: const Text("Upload Image",
                              style: TextStyle(color: Colors.black)),
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
                                    debugPrint(
                                        'savePreviewToGallery result: $res');
                                    debugPrint(
                                        'exportedImageBytes length: ${c.exportedImageBytes.value?.lengthInBytes}');
                                    debugPrint(
                                        'exportedImageBase64 length: ${c.exportedImageBase64.value?.length}');
                                    if (res['ok'] == true) {
                                      final path = res['path']?.toString() ??
                                          '<unknown>';
                                      if (res['warning'] ==
                                          'permission_denied') {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Saved to temp (permission denied): $path')));
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text('Saved: $path')));
                                      }
                                    } else {
                                      final err =
                                          res['error']?.toString() ?? 'unknown';
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Failed to save: $err')));
                                    }
                                  },
                            icon: c.isExporting.value
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2))
                                : const Icon(Icons.download),
                            label: const Text("Preview",
                                style: TextStyle(color: Colors.black)),
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
                  // isFromCustomHub
                  //     ? SizedBox.shrink()
                  //     : Padding(
                  //         padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  //         child: Obx(() => CustomButton(
                  //               onTap: c.isExporting.value
                  //                   ? null
                  //                   : () async {
                  //                       if (c.imagePath.value == null) {
                  //                         toastMessage(
                  //                             message:
                  //                                 'Please upload an image');
                  //                         return;
                  //                       }
                  //                       // prepare payload (exports and stores bytes/base64)
                  //                       final ok =
                  //                           await c.prepareOrderPayload();
                  //                       if (!ok ||
                  //                           c.exportedImageBytes.value ==
                  //                               null) {
                  //                         ScaffoldMessenger.of(context)
                  //                             .showSnackBar(const SnackBar(
                  //                                 content: Text(
                  //                                     'Failed to prepare order')));
                  //                         return;
                  //                       }

                  //                       // save exported bytes to a temp file and print path
                  //                       final bytes =
                  //                           c.exportedImageBytes.value!;
                  //                       final tempPath =
                  //                           await c.saveBytesToTempFile(bytes);
                  //                       debugPrint(
                  //                           'CustomDesign exported image path: $tempPath');
                  //                       debugPrint("VendorId: $vendorId");

                  //                       // create a minimal controller object expected by AddAddressScreen
                  //                       // final orderController = OrderFormController();
                  //                       final customOrderController = Get.put(
                  //                           ProductDetailsController(
                  //                               basePrice: 0));

                  //                       // navigate to AddAddressScreen passing the temp image path
                  //                       context.pushNamed(
                  //                         RoutePath.addAddressScreen,
                  //                         extra: {
                  //                           'vendorId': vendorId,
                  //                           'productId': '',
                  //                           'controller': customOrderController,
                  //                           'isCustomOrder': true,
                  //                           'ProductImage': tempPath ?? '',
                  //                           'productName': '',
                  //                           'productCategoryName': '',
                  //                         },
                  //                       );
                  //                     },
                  //               title: c.isExporting.value
                  //                   ? 'Processing...'
                  //                   : 'Place Order',
                  //               height: 48,
                  //             )),
                  //       ),
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
