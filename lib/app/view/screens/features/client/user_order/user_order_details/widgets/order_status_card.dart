import 'package:flutter/material.dart';
import 'package:local/app/global/helper/extension/extension.dart';

class OrderStatusCard extends StatelessWidget {
  final String status;
  final String? time;
  final String? message;

  const OrderStatusCard({
    super.key,
    required this.status,
    this.time,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final normalizedStatus = status.toLowerCase();
    
    // Don't show card for statuses that have action cards
    if (_shouldHideCard(normalizedStatus)) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        gradient: _getGradient(normalizedStatus),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: _getBorderColor(normalizedStatus),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _getShadowColor(normalizedStatus),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: _getIconBackgroundColor(normalizedStatus),
                shape: BoxShape.circle,
                border: Border.all(
                  color: _getIconBorderColor(normalizedStatus),
                  width: 2,
                ),
              ),
              child: Icon(
                _getIcon(normalizedStatus),
                color: _getIconColor(normalizedStatus),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getTitle(normalizedStatus),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: _getTextColor(normalizedStatus),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    message ?? _getDescription(normalizedStatus),
                    style: TextStyle(
                      fontSize: 14,
                      color: _getSecondaryTextColor(normalizedStatus),
                      height: 1.3,
                    ),
                  ),
                  if (time != null) ...[
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 12,
                          color: _getSecondaryTextColor(normalizedStatus),
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          TextSpan(text: '${_getTimePrefix(normalizedStatus)}: '),
                          TextSpan(
                            text: time?.getDateTime() ?? '',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w700,
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

  bool _shouldHideCard(String status) {
    return status == 'offered' ||
           status == 'pending' ||
           status == 'delivery-requested';
  }

  LinearGradient _getGradient(String status) {
    switch (status) {
      case 'accepted':
      case 'completed':
      case 'delivered':
      case 'delivery-confirmed':
        return LinearGradient(
          colors: [Colors.green[50]!, Colors.green[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'in-progress':
        return LinearGradient(
          colors: [Colors.blue[50]!, Colors.blue[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'cancelled':
      case 'rejected':
        return LinearGradient(
          colors: [Colors.red[50]!, Colors.red[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'revision':
        return LinearGradient(
          colors: [Colors.orange[50]!, Colors.orange[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return LinearGradient(
          colors: [Colors.grey[50]!, Colors.grey[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  Color _getBorderColor(String status) {
    switch (status) {
      case 'accepted':
      case 'completed':
      case 'delivered':
        return Colors.green[300]!;
      case 'in-progress':
        return Colors.blue[300]!;
      case 'cancelled':
      case 'rejected':
        return Colors.red[300]!;
      case 'revision':
        return Colors.orange[300]!;
      default:
        return Colors.grey[300]!;
    }
  }

  Color _getShadowColor(String status) {
    switch (status) {
      case 'accepted':
      case 'completed':
      case 'delivered':
      case 'delivery-confirmed':
        return Colors.green.withValues(alpha: 0.15);
      case 'in-progress':
        return Colors.blue.withValues(alpha: 0.15);
      case 'cancelled':
      case 'rejected':
        return Colors.red.withValues(alpha: 0.15);
      case 'revision':
        return Colors.orange.withValues(alpha: 0.15);
      default:
        return Colors.grey.withValues(alpha: 0.1);
    }
  }

  IconData _getIcon(String status) {
    switch (status) {
      case 'accepted':
        return Icons.check_circle_outline;
      case 'completed':
      case 'delivered':
        return Icons.task_alt;
      case 'delivery-confirmed':
        return Icons.verified;
      case 'in-progress':
        return Icons.hourglass_empty;
      case 'cancelled':
      case 'rejected':
        return Icons.cancel_outlined;
      case 'revision':
        return Icons.edit_note;
      default:
        return Icons.info_outline;
    }
  }

  Color _getIconColor(String status) {
    switch (status) {
      case 'accepted':
      case 'completed':
      case 'delivered':
      case 'delivery-confirmed':
        return Colors.green[600]!;
      case 'in-progress':
        return Colors.blue[600]!;
      case 'cancelled':
      case 'rejected':
        return Colors.red[600]!;
      case 'revision':
        return Colors.orange[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  Color _getIconBackgroundColor(String status) {
    switch (status) {
      case 'accepted':
      case 'completed':
      case 'delivered':
      case 'delivery-confirmed':
        return Colors.green[100]!;
      case 'in-progress':
        return Colors.blue[100]!;
      case 'cancelled':
      case 'rejected':
        return Colors.red[100]!;
      case 'revision':
        return Colors.orange[100]!;
      default:
        return Colors.grey[100]!;
    }
  }

  Color _getIconBorderColor(String status) {
    switch (status) {
      case 'accepted':
      case 'completed':
      case 'delivered':
      case 'delivery-confirmed':
        return Colors.green[300]!;
      case 'in-progress':
        return Colors.blue[300]!;
      case 'cancelled':
      case 'rejected':
        return Colors.red[300]!;
      case 'revision':
        return Colors.orange[300]!;
      default:
        return Colors.grey[300]!;
    }
  }

  Color _getTextColor(String status) {
    switch (status) {
      case 'accepted':
      case 'completed':
      case 'delivered':
      case 'delivery-confirmed':
        return Colors.green[700]!;
      case 'in-progress':
        return Colors.blue[700]!;
      case 'cancelled':
      case 'rejected':
        return Colors.red[700]!;
      case 'revision':
        return Colors.orange[700]!;
      default:
        return Colors.grey[700]!;
    }
  }

  Color _getSecondaryTextColor(String status) {
    switch (status) {
      case 'accepted':
      case 'completed':
      case 'delivered':
      case 'delivery-confirmed':
        return Colors.green[600]!;
      case 'in-progress':
        return Colors.blue[600]!;
      case 'cancelled':
      case 'rejected':
        return Colors.red[600]!;
      case 'revision':
        return Colors.orange[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  String _getTitle(String status) {
    switch (status) {
      case 'accepted':
        return 'Offer Accepted!';
      case 'completed':
        return 'Order Completed!';
      case 'delivered':
        return 'Order Delivered!';
      case 'delivery-confirmed':
        return 'Delivery Confirmed!';
      case 'in-progress':
        return 'Order In Progress';
      case 'cancelled':
        return 'Order Cancelled';
      case 'rejected':
        return 'Offer Rejected';
      case 'revision':
        return 'Revision Requested';
      default:
        return 'Order Status Update';
    }
  }

  String _getDescription(String status) {
    switch (status) {
      case 'accepted':
        return 'You have accepted this offer. The vendor will start working on your order soon.';
      case 'completed':
        return 'Your order has been completed successfully. Thank you for your business!';
      case 'delivered':
        return 'Your order has been delivered. We hope you love your custom product!';
      case 'delivery-confirmed':
        return 'You have confirmed the delivery of your order. Thank you for your confirmation!';
      case 'in-progress':
        return 'Your order is currently being processed. We\'ll update you on the progress.';
      case 'cancelled':
        return 'This order has been cancelled. If you have any questions, please contact support.';
      case 'rejected':
        return 'This offer has been rejected. You can browse other offers or contact the vendor.';
      case 'revision':
        return 'You have requested a revision for this order. The vendor will address your concerns.';
      default:
        return 'Your order status has been updated.';
    }
  }

  String _getTimePrefix(String status) {
    switch (status) {
      case 'accepted':
        return 'Accepted at';
      case 'completed':
        return 'Completed at';
      case 'delivered':
        return 'Delivered at';
      case 'delivery-confirmed':
        return 'Confirmed at';
      case 'in-progress':
        return 'Started at';
      case 'cancelled':
        return 'Cancelled at';
      case 'rejected':
        return 'Rejected at';
      case 'revision':
        return 'Revision requested at';
      default:
        return 'Updated at';
    }
  }
}