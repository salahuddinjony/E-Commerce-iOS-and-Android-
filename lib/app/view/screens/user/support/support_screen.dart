import 'package:flutter/material.dart';
import 'package:local/app/view/common_widgets/nav_bar/nav_bar.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: CustomNavBar(currentIndex: 3),
    );
  }
}
