import 'package:flutter/material.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_network_image/custom_network_image.dart';

class CustomOrderScreen extends StatelessWidget {
  const CustomOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarContent: "Custom Design Overview",
        iconData: Icons.arrow_back,
      ),
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row with image and details
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomNetworkImage(
                      imageUrl: AppConstants.teeShirt, height: 150, width: 200),
                  const SizedBox(width: 15),
                  // Product details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Guitar Soul Tee',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Supreme Soft Cotton',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            ),
                            children: [
                              const TextSpan(text: 'These '),
                              TextSpan(
                                text: 'T-shirts',
                                style: TextStyle(
                                  color: Colors.blue.shade600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              const TextSpan(
                                  text:
                                      ' are dominating the fashion scene with their unique designs and top-quality fabric. Pick your favorite now!'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Row(
                          children: [
                            Text(
                              'QTY: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              '1',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.blue,
                              ),
                            ),

                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),

              // Order Summary section
              const Text(
                'Order Summary',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: 0.3),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Delivery',
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  Text(
                    '\$4.00',
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  )
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Hub Fee',
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  Text(
                    '20%',
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  )
                ],
              ),
              const Divider(height: 30, thickness: 1),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Total',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    '\$24.00',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )
                ],
              ),

              const SizedBox(height: 30),

              // Delivery section
              const Text(
                'Delivery',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: 0.3),
              ),
              const SizedBox(height: 10),
              const Text(
                'Address',
                style: TextStyle(fontSize: 15, color: Colors.black87),
              ),
              const SizedBox(height: 6),
              const Text(
                '847 Jewess Bridge Apt. 174 , UK',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 3),
              const Text(
                '474-769-3919',
                style: TextStyle(fontSize: 14),
              ),

              const SizedBox(height: 40),

              // Payment options
              const Text(
                'Payment Options',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    letterSpacing: 0.3),
              ),




              const SizedBox(height: 25),

              // Apple Pay button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brightCyan,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.apple,color: AppColors.white,),
                label: const Text(
                  'Apple Pay',
                  style: TextStyle(fontSize: 16,color: AppColors.white),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
