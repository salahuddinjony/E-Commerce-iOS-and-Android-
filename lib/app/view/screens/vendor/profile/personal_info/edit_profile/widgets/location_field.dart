import 'package:flutter/material.dart';
import 'package:local/app/view/common_widgets/custom_from_card/custom_from_card.dart';
import '../../controller/profile_controller.dart';

class LocationField extends StatelessWidget {
  final ProfileController controller;
  const LocationField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // Replace with map picker logic later if needed
    return CustomFromCard(
      hinText: 'Tap to pick on map',
      title: 'Location',
      controller: controller.locationController,
      validator: (v) => null,
    );
  }
}