import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local/app/view/screens/authentication/controller/auth_controller.dart';

class CheckPasswordConstraint extends StatelessWidget {
  final AuthController controller;
  const CheckPasswordConstraint({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          Row(
            children: [
              controller.minchar.value
                  ? const Icon(Icons.check, color: Colors.green)
                  : Text(
                      "❃",
                      style: TextStyle(color: Colors.red),
                    ),
              const SizedBox(width: 8),
              const Text("Minimum 8-12 characters"),
            ],
          ),
          Row(
            children: [
              controller.upper.value
                  ? const Icon(Icons.check, color: Colors.green)
                  : Text(
                      "❃",
                      style: TextStyle(color: Colors.red),
                    ),
              const SizedBox(width: 8),
              const Text("At least one uppercase letter (A-Z)"),
            ],
          ),
          Row(
            children: [
              controller.special.value
                  ? const Icon(Icons.check, color: Colors.green)
                  : Text(
                      "❃",
                      style: TextStyle(color: Colors.red),
                    ),
              const SizedBox(width: 8),
              const Text("At least one special character (!, @, #, \$, etc.)"),
            ],
          ),
          Row(
            children: [
              controller.number.value
                  ? const Icon(Icons.check, color: Colors.green)
                  : Text(
                      "❃",
                      style: TextStyle(color: Colors.red),
                    ),
              const SizedBox(width: 8),
              const Text("At least one number (0-9)"),
            ],
          ),
        ],
      ),
    );
  }
}
