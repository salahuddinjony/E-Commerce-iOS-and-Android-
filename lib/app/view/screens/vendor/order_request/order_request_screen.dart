import 'package:flutter/material.dart';
import 'package:local/app/view/common_widgets/owner_nav/owner_nav.dart';

class OrderRequestScreen extends StatelessWidget {
  const OrderRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: OwnerNav(currentIndex: 3),

    );
  }
}
