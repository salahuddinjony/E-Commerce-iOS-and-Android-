import 'package:flutter/material.dart';
import 'package:local/app/global/helper/extension/extension.dart';


class OfferAcceptCard extends StatelessWidget {
  final String? time; 
   OfferAcceptCard({super.key, this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[50]!, Colors.green[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.green[300]!, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withValues(alpha: .1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.green[500],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Offer Accepted!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'You have accepted this offer. Keeping track of the order status.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green[600],
                      height: 1.3,
                    ),
                  ),
                    if (time != null) ...[
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green[500],
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        const TextSpan(text: 'Accepted at: '),
                        TextSpan(
                        text: '${time?.getDateTime()}',
                        style: const TextStyle(
                          color: Colors.blue, // Make time blue
                          fontWeight: FontWeight.w800,
                        ),
                        ),
                      ],
                      ),
                    ), 
                    
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
