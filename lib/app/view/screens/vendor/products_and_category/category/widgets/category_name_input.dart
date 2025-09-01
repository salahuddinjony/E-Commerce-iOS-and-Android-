import 'package:flutter/material.dart';
import 'package:local/app/view/screens/vendor/products_and_category/category/controller/category_controller.dart';

class CategoryNameInputWidget extends StatelessWidget {
  final CategoryController categoryController;

  const CategoryNameInputWidget({super.key, required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category Name',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: categoryController.nameController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Enter category name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          onChanged: categoryController.setName,
        ),
      ],
    );
  }
}