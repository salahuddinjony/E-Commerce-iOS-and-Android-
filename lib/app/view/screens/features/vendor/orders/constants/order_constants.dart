import 'package:flutter/material.dart';

class OrderConstants {
  // Order Status Constants
  static const String statusOffered = 'offered';
  static const String statusProcess = 'process';
  static const String statusOrdered = 'ordered';
  static const String statusDelivered = 'delivered';
  static const String statusPending = 'pending';
  static const String statusAccepted = 'accepted';
  static const String statusInProgress = 'in-progress';
  static const String statusDeliveryRequested = 'delivery-requested';
  static const String statusDeliveryConfirmed = 'delivery-confirmed';
  static const String statusRevision = 'revision';
  static const String statusCancelled = 'cancelled';
  static const String statusRejected = 'rejected';
  static const String statusCompleted = 'completed';

  // Payment Status Constants
  static const String paymentStatusDue = 'due';
  static const String paymentStatusPaid = 'paid';
  static const String paymentStatusHold = 'hold';
  static const String paymentStatusRefunded = 'refunded';

  // Order Status Card Attributes

  // Statuses that should be hidden (have action cards instead)
  static const List<String> hiddenStatuses = [
    statusOffered,
    statusDeliveryRequested,
  ];

  // Status Titles
  static const Map<String, String> statusTitles = {
    statusAccepted: 'Offer Accepted!',
    statusCompleted: 'Order Completed!',
    statusDelivered: 'Order Delivered!',
    statusDeliveryConfirmed: 'Delivery Confirmed!',
    statusInProgress: 'Order In Progress',
    statusProcess: 'Order In Progress',
    statusCancelled: 'Order Cancelled',
    statusRejected: 'Offer Rejected',
    statusRevision: 'Revision Requested',
    statusPending: 'Order Pending',
    statusOrdered: 'Order Pending',
  };

  // Status Descriptions
  static const Map<String, String> statusDescriptions = {
    statusAccepted:
        'You have accepted this offer. The vendor will start working on your order soon.',
    statusCompleted:
        'Your order has been completed successfully. Thank you for your business!',
    statusDelivered:
        'Your order has been delivered. We hope you love our product!',
    statusDeliveryConfirmed:
        'You have confirmed the delivery of your order. Thank you for your confirmation!',
    statusInProgress:
        'Your order is currently being processed. We\'ll update you on the progress.',
    statusProcess:
        'Your order is currently being processed. We\'ll update you on the progress.',
    statusCancelled:
        'This order has been cancelled. If you have any questions, please contact support.',
    statusRejected:
        'This offer has been rejected. You can browse other offers or contact the vendor.',
    statusRevision:
        'You have requested a revision for this order. The vendor will address your concerns.',
    statusPending:
        'Your order is pending. We will notify you once it is in-progress by the vendor.',
    statusOrdered:
        'Your order has been placed. We will notify you once it is in-progress by the vendor.',
  };

  // Status Time Prefixes
  static const Map<String, String> statusTimePrefixes = {
    statusAccepted: 'Accepted at',
    statusCompleted: 'Completed at',
    statusDelivered: 'Delivered at',
    statusDeliveryConfirmed: 'Confirmed at',
    statusInProgress: 'Started at',
    statusProcess: 'Started at',
    statusCancelled: 'Cancelled at',
    statusRejected: 'Rejected at',
    statusRevision: 'Revision requested at',
    statusPending: 'Ordered at',
    statusOrdered: 'Ordered at',
  };

  // Status Icons (using IconData objects)
  static final Map<String, IconData> statusIcons = {
    statusAccepted: Icons.check_circle_outline,
    statusCompleted: Icons.task_alt,
    statusDelivered: Icons.task_alt,
    statusDeliveryConfirmed: Icons.verified,
    statusInProgress: Icons.hourglass_empty,
    statusProcess: Icons.hourglass_empty,
    statusCancelled: Icons.cancel_outlined,
    statusRejected: Icons.cancel_outlined,
    statusRevision: Icons.edit_note,
    statusPending: Icons.schedule,
    statusOrdered: Icons.schedule,
  };

  // Status Color Groups for easier maintenance
  static const Map<String, String> statusColorGroups = {
    statusAccepted: 'green',
    statusCompleted: 'green',
    statusDelivered: 'green',
    statusDeliveryConfirmed: 'green',
    statusInProgress: 'blue',
    statusProcess: 'blue',
    statusPending: 'purple',
    statusOrdered: 'purple',
    statusCancelled: 'red',
    statusRejected: 'red',
    statusRevision: 'orange',
  };

  // Delivery Options
  static const String deliveryOptionCourier = 'courier';
  static const String deliveryOptionPickup = 'pickup';
  static const String deliveryOptionDelivery = 'delivery';

  // Tab Names
  static const List<String> generalTabs = [
    'All Orders',
    'Pending',
    'in Progress',
    'Rejected'
  ];

  static const List<String> customTabs = [
    'Offered',
    'Accepted Offers',
    'Delivery Requested',
    'Delivered',
    'Revision',
    'Cancelled'
  ];

  // Status Display Text Mapping
  static const Map<String, String> statusDisplayText = {
    statusOffered: 'Offered',
    statusPending: 'Pending',
    statusProcess: 'In Process',
    statusOrdered: 'Ordered',
    statusDelivered: 'Delivered',
    statusAccepted: 'Accepted',
    statusInProgress: 'In Progress',
    statusDeliveryRequested: 'Delivery Requested',
    statusDeliveryConfirmed: 'Delivery Confirmed',
    statusRevision: 'Revision',
    statusCancelled: 'Cancelled',
    statusRejected: 'Rejected',
    statusCompleted: 'Completed',
  };

  // Payment Status Display Text Mapping
  static const Map<String, String> paymentStatusDisplayText = {
    paymentStatusDue: 'Due',
    paymentStatusPaid: 'Paid',
    paymentStatusHold: 'Hold',
    paymentStatusRefunded: 'Refunded',
  };

  // Status Color Mapping (ARGB format)
  static const Map<String, int> statusColors = {
    statusOffered: 0xFFFFA500, // Orange
    statusProcess: 0xFF2196F3, // Blue (same as In Progress)
    statusOrdered: 0xFFFFA500, // Orange
    statusDelivered: 0xFF4CAF50, // Green
    statusPending: 0xFFFFA500, // Orange
    statusAccepted: 0xFF2196F3, // Blue
    statusInProgress: 0xFF2196F3, // Blue
    statusDeliveryRequested: 0xFF9C27B0, // Purple
    statusDeliveryConfirmed: 0xFF4CAF50, // Green
    statusRevision: 0xFF7E57C2, // Deep Purple (indicates revision/changes)
    statusCancelled: 0xFFF44336, // Red
    statusRejected: 0xFFF44336, // Red
    statusCompleted: 0xFF4CAF50, // Green
  };

  // Payment Status Color Mapping (ARGB format)
  static const Map<String, int> paymentStatusColors = {
    paymentStatusDue: 0xFFFF9800, // Orange
    paymentStatusPaid: 0xFF4CAF50, // Green
    paymentStatusHold: 0xFFFFC107, // Amber
    paymentStatusRefunded: 0xFFF44336, // Red
  };

  // Get status display text
  static String getStatusDisplayText(String status) {
    return statusDisplayText[status] ?? status;
  }

  // Get payment status display text
  static String getPaymentStatusDisplayText(String paymentStatus) {
    return paymentStatusDisplayText[paymentStatus] ?? paymentStatus;
  }

  // Get status color
  static int getStatusColor(String status) {
    return statusColors[status] ?? 0xFF757575; // Default grey
  }

  // Get payment status color
  static int getPaymentStatusColor(String paymentStatus) {
    return paymentStatusColors[paymentStatus] ?? 0xFF757575; // Default grey
  }

  // Check if status is pending
  static bool isPendingStatus(String status) {
    return status == statusOffered || status == statusPending;
  }

  // Check if status is in progress
  static bool isInProgressStatus(String status) {
    return status == statusAccepted || status == statusInProgress;
  }

  // Check if status is completed
  static bool isCompletedStatus(String status) {
    return status == statusDeliveryConfirmed || status == statusCompleted;
  }
  //check if status is delivered
  static bool isDeliveredStatus(String status) {
    return status == statusDelivered;
  }
  // Check if status is revision
  static bool isRevisionStatus(String status) {
    return status == statusRevision;
  }
  //check delivery requested status
  static bool isDeliveryRequestedStatus(String status) {
    return status == statusDeliveryRequested;
  }
  // delivery confirmed status
  static bool isDeliveryConfirmedStatus(String status) {
    return status == statusDeliveryConfirmed;
  }

  // Check if status is cancelled/rejected
  static bool isCancelledStatus(String status) {
    return status == statusCancelled || status == statusRejected;
  }

  // Order Status Card Helper Methods

  // Check if status should be hidden
  static bool shouldHideStatusCard(String status) {
    return hiddenStatuses.contains(status.toLowerCase());
  }

  // Get status title
  static String getStatusTitle(String status) {
    return statusTitles[status.toLowerCase()] ?? 'Order Status Update';
  }

  // Get status description
  static String getStatusDescription(String status) {
    return statusDescriptions[status.toLowerCase()] ??
        'Your order status has been updated.';
  }

  // Get status time prefix
  static String getStatusTimePrefix(String status) {
    return statusTimePrefixes[status.toLowerCase()] ?? 'Updated at';
  }

  // Get status icon
  static IconData getStatusIcon(String status) {
    return statusIcons[status.toLowerCase()] ?? Icons.info_outline;
  }

  // Get status color group
  static String getStatusColorGroup(String status) {
    return statusColorGroups[status.toLowerCase()] ?? 'grey';
  }

  // Get primary color based on color group (ARGB format)
  static int getPrimaryColorByGroup(String colorGroup) {
    switch (colorGroup) {
      case 'green':
        return 0xFF4CAF50;
      case 'blue':
        return 0xFF2196F3;
      case 'purple':
        return 0xFF9C27B0;
      case 'red':
        return 0xFFF44336;
      case 'orange':
        return 0xFFFF9800;
      default:
        return 0xFF757575; // grey
    }
  }

  // Get light color based on color group (ARGB format)
  static int getLightColorByGroup(String colorGroup) {
    switch (colorGroup) {
      case 'green':
        return 0xFFC8E6C9;
      case 'blue':
        return 0xFFBBDEFB;
      case 'purple':
        return 0xFFE1BEE7;
      case 'red':
        return 0xFFFFCDD2;
      case 'orange':
        return 0xFFFFE0B2;
      default:
        return 0xFFE0E0E0; // grey
    }
  }

  // Get extra light color based on color group (ARGB format)
  static int getExtraLightColorByGroup(String colorGroup) {
    switch (colorGroup) {
      case 'green':
        return 0xFFE8F5E8;
      case 'blue':
        return 0xFFE3F2FD;
      case 'purple':
        return 0xFFF3E5F5;
      case 'red':
        return 0xFFFFEBEE;
      case 'orange':
        return 0xFFFFF3E0;
      default:
        return 0xFFF5F5F5; // grey
    }
  }

  // Order Action Card Attributes

  // Statuses that should show action cards
  static const List<String> actionCardStatuses = [
    statusOffered,
    statusPending,
    statusDeliveryRequested,
  ];

  // Action Card Titles
  static const Map<String, String> actionCardTitles = {
    statusOffered: 'New Offer Received!',
    statusPending: 'New Offer Received!',
    statusDeliveryRequested: 'Delivery Confirmation',
  };

  // Action Card Descriptions
  static const Map<String, String> actionCardDescriptions = {
    statusOffered: 'You have received a new offer for your custom order. Please review the details and decide whether to accept or reject this offer.',
    statusPending: 'You have received a new offer for your custom order. Please review the details and decide whether to accept or reject this offer.',
    statusDeliveryRequested: 'The vendor has requested delivery confirmation. Please confirm if you have received your order or request a revision if needed.',
  };

  // Action Card Icons
  static final Map<String, IconData> actionCardIcons = {
    statusOffered: Icons.local_offer_outlined,
    statusPending: Icons.local_offer_outlined,
    statusDeliveryRequested: Icons.local_shipping_outlined,
  };

  // Action Card Color Groups
  static const Map<String, String> actionCardColorGroups = {
    statusOffered: 'blue',
    statusPending: 'blue',
    statusDeliveryRequested: 'orange',
  };

  // Action Card Button Configurations
  static final Map<String, List<Map<String, dynamic>>> actionCardButtons = {
    statusOffered: [
      {
        'title': 'Accept Offer',
        'icon': Icons.check_circle_outline,
        'colorGroup': 'green',
        'action': 'accept_offer',
      },
      {
        'title': 'Reject Offer',
        'icon': Icons.cancel_outlined,
        'colorGroup': 'red',
        'action': 'reject_offer',
      },
    ],
    statusPending: [
      {
        'title': 'Accept Offer',
        'icon': Icons.check_circle_outline,
        'colorGroup': 'green',
        'action': 'accept_offer',
      },
      {
        'title': 'Reject Offer',
        'icon': Icons.cancel_outlined,
        'colorGroup': 'red',
        'action': 'reject_offer',
      },
    ],
    statusDeliveryRequested: [
      {
        'title': 'Accept',
        'icon': Icons.check_circle_outline,
        'colorGroup': 'green',
        'action': 'delivery-confirmed',
      },
      {
        'title': 'Revision',
        'icon': Icons.edit_note,
        'colorGroup': 'orange',
        'action': 'request_revision',
      },
    ],
  };

  // Order Action Card Helper Methods

  // Check if status should show action card
  static bool shouldShowActionCard(String status) {
    return actionCardStatuses.contains(status.toLowerCase());
  }

  // Get action card title
  static String getActionCardTitle(String status) {
    return actionCardTitles[status.toLowerCase()] ?? 'Action Required';
  }

  // Get action card description
  static String getActionCardDescription(String status) {
    return actionCardDescriptions[status.toLowerCase()] ?? 'Please take action on this order.';
  }

  // Get action card icon
  static IconData getActionCardIcon(String status) {
    return actionCardIcons[status.toLowerCase()] ?? Icons.info_outline;
  }

  // Get action card color group
  static String getActionCardColorGroup(String status) {
    return actionCardColorGroups[status.toLowerCase()] ?? 'grey';
  }

  // Get action card buttons configuration
  static List<Map<String, dynamic>> getActionCardButtons(String status) {
    return List<Map<String, dynamic>>.from(
      actionCardButtons[status.toLowerCase()] ?? []
    );
  }

  // Get color by color group name
  static Color getColorByGroup(String colorGroup) {
    return Color(getPrimaryColorByGroup(colorGroup));
  }
}
