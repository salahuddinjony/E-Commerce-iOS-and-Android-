import 'package:flutter/material.dart';
import '../widgets/category_grid_section.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

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

