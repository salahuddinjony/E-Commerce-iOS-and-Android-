import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';

import '../../../../../../core/route_path.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int items = 1;
  String size = 'S';

  bool standardShipping = false;
  bool expressShipping = false;
  bool homeDelivery = false;

  final double basePrice = 20.22;
  final double standardShippingCost = 10;
  final double expressShippingCost = 10;
  final double homeDeliveryCost = 8;
  final double hubFeePercent = 0.2;

  @override
  Widget build(BuildContext context) {
    double shippingCost = 0;
    if (standardShipping) shippingCost += standardShippingCost;
    if (expressShipping) shippingCost += expressShippingCost;
    if (homeDelivery) shippingCost += homeDeliveryCost;

    double subTotal = basePrice * items + shippingCost;
    double totalCost = subTotal + subTotal * hubFeePercent;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        appBarContent: "Product Details",
        iconData: Icons.arrow_back,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main product image
            Center(
              child: Container(
                width: 400,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(AppConstants.teeShirt),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Title and subtitle
            const Text(
              'Guitar Soul Tee',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Supreme Soft Cotton',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black87, fontSize: 14),
                children: [
                  const TextSpan(text: 'These '),
                  TextSpan(
                    text: 'T-shirts',
                    style: TextStyle(color: Colors.blue.shade700),
                  ),
                  const TextSpan(
                      text:
                          ' are dominating the fashion scene with their unique designs and top-quality fabric. Pick your favorite now!'),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '\$20.22',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Rating and sold
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                const Text('4.5'),
                const SizedBox(width: 16),
                const Text('Sold (100)'),
              ],
            ),
            const SizedBox(height: 16),
            // Thumbnails row (placeholder images)
            SizedBox(
              height: 70,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _thumbnail(AppConstants.teeShirt),
                  _thumbnail(AppConstants.teeShirt),
                  _thumbnail(AppConstants.teeShirt),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Items counter
            const Text('Items', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                _counterButton('-', () {
                  setState(() {
                    if (items > 1) items--;
                  });
                }),
                Container(
                  width: 50,
                  color: AppColors.white,
                  alignment: Alignment.center,
                  child: Text('$items', style: const TextStyle(fontSize: 18)),
                ),
                _counterButton('+', () {
                  setState(() {
                    items++;
                  });
                }),
              ],
            ),
            const SizedBox(height: 16),
            // Size options
            const Text('Size', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              children: ['S', 'M', 'L', 'XL', 'XXL']
                  .map(
                    (s) => ChoiceChip(
                      label: Text(s),
                      selected: size == s,
                      onSelected: (selected) {
                        setState(() {
                          size = s;
                        });
                      },
                      selectedColor: Colors.teal,
                      // background color when selected
                      backgroundColor: Colors.grey[200],
                      // background color when not selected
                      labelStyle: TextStyle(
                        color: size == s
                            ? Colors.white
                            : Colors.black, // label color depending on state
                      ),
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 16),
            // Shipping options
            const Text('Shipping Options:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            CheckboxListTile(
              title: const Text('Standard Shipping (5-7 days)'),
              value: standardShipping,
              onChanged: (val) {
                setState(() {
                  standardShipping = val ?? false;
                });
              },
              secondary: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.teal),
                    borderRadius: BorderRadius.circular(8)),
                child: const Text('\$10', style: TextStyle(color: Colors.teal)),
              ),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              title: const Text('Express Shipping (2-3 days)'),
              value: expressShipping,
              onChanged: (val) {
                setState(() {
                  expressShipping = val ?? false;
                });
              },
              secondary: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.teal),
                    borderRadius: BorderRadius.circular(8)),
                child: const Text('\$10', style: TextStyle(color: Colors.teal)),
              ),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const SizedBox(height: 8),
            // Delivery option
            const Text('Delivery Option:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            CheckboxListTile(
              title: const Text('Home Delivery'),
              value: homeDelivery,
              onChanged: (val) {
                setState(() {
                  homeDelivery = val ?? false;
                });
              },
              secondary: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.teal),
                    borderRadius: BorderRadius.circular(8)),
                child: const Text('\$8', style: TextStyle(color: Colors.teal)),
              ),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const SizedBox(height: 8),
            const Text('Hub Fee 20%',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Total Cost: \$${totalCost.toStringAsFixed(0)}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.teal)),
            const SizedBox(height: 16),
            CustomButton(
              onTap: () {
                context.pushNamed(
                  RoutePath.addAddressScreen,
                );
              },
              title: "order Now",
            ),
            const SizedBox(height: 16),

          ],
        ),
      ),
    );
  }

  Widget _counterButton(String label, VoidCallback onPressed) {
    return SizedBox(
      width: 36,
      height: 36,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            foregroundColor: Colors.deepOrange,
            backgroundColor: AppColors.white),
        child: Text(label, style: const TextStyle(fontSize: 22)),
      ),
    );
  }

  Widget _thumbnail(String url) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover)),
    );
  }
}
