import 'package:flutter/material.dart';

class NameAndLocation extends StatelessWidget {
  final String displayName;
  final String displayLocation;
  const NameAndLocation({super.key, required this.displayName, required this.displayLocation});

  @override
  Widget build(BuildContext context) {
    return  Positioned(
            top: 170,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  displayName,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on, color: Colors.white70, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '$displayLocation',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}