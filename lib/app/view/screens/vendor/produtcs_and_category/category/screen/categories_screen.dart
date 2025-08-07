import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/category_controller.dart';
import '../widgets/category_grid_section.dart';

class CategoriesScreen extends StatelessWidget {
  CategoriesScreen({super.key});
  final CategoryController categoryController = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
     
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CategoryGridSection(),
      ),
    );
  }
}

