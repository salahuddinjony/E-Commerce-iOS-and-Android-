import 'package:flutter/material.dart';
import 'package:local/app/view/common_widgets/owner_nav/owner_nav.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: OwnerNav(currentIndex: 4),

    );
  }
}
