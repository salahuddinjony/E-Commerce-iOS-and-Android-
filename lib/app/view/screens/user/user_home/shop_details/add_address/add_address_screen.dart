import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';

import '../../../../../../core/route_path.dart';

class AddAddressScreen extends StatelessWidget {
  const AddAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Add Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Recipient’s Name',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'Real name',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Contact Number',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Phone Number',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('City/Region',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'city/region',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Address',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'House no./building/area',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 20.h,),
            CustomButton(
              onTap: () {
                context.pushNamed(
                  RoutePath.customOrderScreen,
                );
              },
              title: "next",
            )
          ],
        ),
      ),
    );
  }
}
