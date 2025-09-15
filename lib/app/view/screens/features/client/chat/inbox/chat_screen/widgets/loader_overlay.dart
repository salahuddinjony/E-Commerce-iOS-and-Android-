import 'package:flutter/material.dart';

class LoaderOverlay extends StatelessWidget {
  final double opacity;
  const LoaderOverlay({super.key, this.opacity = .05});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: opacity),
        child: const Center(
          child: SizedBox(
            width: 160, 
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}