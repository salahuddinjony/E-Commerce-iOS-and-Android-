import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/view/common_widgets/confirm_dialog_box.dart/confirm_dialog.dart';
import 'package:local/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:local/app/view/screens/vendor/products_and_category/category/add_category/add_category.dart';
import 'package:local/app/view/screens/vendor/products_and_category/category/model/category_response.dart';
import '../controller/category_controller.dart';
import 'dart:io';

class CategoryCard extends StatelessWidget {
  final CategoryData category;
  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 Expanded(
                   child: CustomNetworkImage(
                      imageUrl:
                          category.image, // fallback to empty string if null
                      height: 119.h,
                      width: 119.w,
                    ),
                 ),
                  const SizedBox(height: 8),
                 Expanded(
                   child: Text(
                        category.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                 ),
                ],
              ),
            ),
            Positioned(
              right: -10,
              top: 0,
              child: PopupMenuButton<String>(
                color: Colors.white,
                icon: Icon(Icons.more_vert, size: 20, color: Colors.grey[800]),
                onSelected: (value) {
                  if (value == 'edit') {
                    Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  AddCategory()),
              );
                  
                  } else if (value == 'delete') {
                    showDialog(
                      context: context,
                      builder: (context) => ConfirmDialog(  title: 'Delete Category',
                            content:
                                'Are you sure you want to delete this category?', onConfirm: () { 
                        //  Navigator.pop(context);
        
        
                       },)
                    );
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
