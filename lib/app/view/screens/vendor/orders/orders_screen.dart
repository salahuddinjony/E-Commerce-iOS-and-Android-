import 'package:flutter/material.dart';
import 'package:local/app/view/common_widgets/owner_nav/owner_nav.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: OwnerNav(currentIndex: 1),
    );
  }
}
