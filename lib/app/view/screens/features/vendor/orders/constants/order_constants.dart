class OrderConstants {
  // Order Status Constants
  static const String statusOffered = 'offered';
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

  // Delivery Options
  static const String deliveryOptionCourier = 'courier';
  static const String deliveryOptionPickup = 'pickup';
  static const String deliveryOptionDelivery = 'delivery';

  // Tab Names
  static const List<String> generalTabs = [
    'All Orders',
    'Pending',
    'Completed',
    'Rejected'
  ];

  static const List<String> customTabs = [
    'Pending',
    'In Progress',
    'Completed',
    'Cancelled'
  ];

  // Status Display Text Mapping
  static const Map<String, String> statusDisplayText = {
    statusOffered: 'Offered',
    statusPending: 'Pending',
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
    statusPending: 0xFFFFA500, // Orange
    statusAccepted: 0xFF2196F3, // Blue
    statusInProgress: 0xFF2196F3, // Blue
    statusDeliveryRequested: 0xFF9C27B0, // Purple
    statusDeliveryConfirmed: 0xFF4CAF50, // Green
    statusRevision: 0xFFFF9800, // Orange
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

  // Check if status is cancelled/rejected
  static bool isCancelledStatus(String status) {
    return status == statusCancelled || status == statusRejected;
  }
} 