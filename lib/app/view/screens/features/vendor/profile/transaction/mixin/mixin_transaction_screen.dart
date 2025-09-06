import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin MixinTransactionScreen on GetxController {
  final RxString searchQuery = ''.obs;
  final RxBool isTyping = false.obs;

  // Optional type filter: 'credit' | 'debit'
  final filterType = RxnString();

  late final TextEditingController searchController;
  late final FocusNode searchFocusNode;

  Timer? _debounce;
  static const _typingDelay = Duration(milliseconds: 500);

  @override
  void onInit() {
    super.onInit();
    searchController = TextEditingController();
    searchFocusNode = FocusNode();
    searchFocusNode.addListener(() {
      if (!searchFocusNode.hasFocus) {
        isTyping.value = false;
      }
    });
  }

  void onChanged(String value) {
    searchQuery.value = value.trim();
    isTyping.value = true;
    _debounce?.cancel();
    _debounce = Timer(_typingDelay, () {
      isTyping.value = false;
    });
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    isTyping.value = false;
  }

  void clearFilter() {
    filterType.value = null;
  }

  // Replacement: avoid deprecated RadioListTile.groupValue.
  // Use ListTile + Radio manually.
  void openFilterSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (sheetCtx) => Obx(
        () => Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Filter Transactions',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 12),
              radioOption(
                ctx: sheetCtx,
                value: 'credit',
                label: 'Credits Only',
              ),
              radioOption(
                ctx: sheetCtx,
                value: 'debit',
                label: 'Debits Only',
              ),
              if (filterType.value != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      clearFilter();
                      Navigator.pop(sheetCtx);
                    },
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear filter'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget radioOption({
    required BuildContext ctx,
    required String value,
    required String label,
  }) {
    return Obx(
      () => ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        leading: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            filterType.value = value;
            Navigator.pop(ctx);
          },
          child: SizedBox(
            width: 36,
            height: 36,
            child: Center(
              child: Icon(
                filterType.value == value
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: filterType.value == value ? Colors.teal : Colors.grey,
              ),
            ),
          ),
        ),
        title: Text(label),
        onTap: () {
          filterType.value = value;
          Navigator.pop(ctx);
        },
      ),
    );
  }

  String get activeFilterLabel {
    switch (filterType.value) {
      case 'credit':
        return 'Credits Only';
      case 'debit':
        return 'Debits Only';
      default:
        return '';
    }
  }

  bool get hasFilter => filterType.value != null;

  @override
  void onClose() {
    _debounce?.cancel();
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }
}
