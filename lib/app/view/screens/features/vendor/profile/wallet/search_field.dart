import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local/app/view/screens/features/vendor/home/controller/home_page_controller.dart';

class SearchField extends StatelessWidget {
  final HomePageController homeController;
  const SearchField({super.key, required this.homeController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: homeController.searchController,
      focusNode: homeController.searchFocusNode,
      decoration: InputDecoration(
        hintText: 'Search by Transaction ID',
        prefixIcon: const Icon(Icons.search),
        isDense: true,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.teal, width: 1.2),
        ),
        suffixIcon: Obx(() {
          final typing = homeController.isTyping.value;
          final hasText = homeController.searchQuery.value.isNotEmpty;
          final hasFilter = homeController.filterType.value != null;

          // While typing: show clear if text
          if (typing) {
            return hasText
                ? IconButton(
                    tooltip: 'Clear',
                    icon: const Icon(Icons.clear),
                    onPressed: homeController.clearSearch,
                  )
                : const SizedBox.shrink();
          }

          // Not typing: show (optional clear) + filter icon (always)
          final icons = <Widget>[
            if (hasText)
              IconButton(
                tooltip: 'Clear',
                icon: const Icon(Icons.clear),
                onPressed: homeController.clearSearch,
              ),
            Stack(
              children: [
                IconButton(
                  tooltip: 'Filter',
                  icon: const Icon(Icons.filter_list),
                  onPressed: () => homeController.openFilterSheet(context),
                ),
                if (hasFilter)
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.teal,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ];

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: icons,
          );
        }),
      ),
      onChanged: homeController.onChanged,
    );
  }
}
