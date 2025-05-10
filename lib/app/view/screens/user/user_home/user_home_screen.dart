import 'package:flutter/material.dart';
import 'package:local/app/view/common_widgets/nav_bar/nav_bar.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: CustomNavBar(currentIndex: 0),
    );
  }
}
