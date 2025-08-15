# Vendor Orders Management

This directory contains the complete order management system for vendors in the U-Tee Hub application.

## Directory Structure

```
orders/
├── constants/
│   └── order_constants.dart          # Order-related constants and status mappings
├── controller/
│   └── order_controller.dart         # Main controller for order management
├── mixins/
│   └── order_mixin.dart              # Mixin for order operations and data management
├── models/
│   └── order_response_model.dart     # Data models for API responses
├── services/
│   └── order_service.dart            # API service for order operations
├── orders_screen.dart                # Main orders screen UI
└── README.md                         # This documentation file
```

## Features

### 1. Order Types
- **General Orders**: Standard product orders
- **Custom Orders**: Personalized/customized orders

### 2. Order Statuses
- **Pending**: `offered`, `pending`
- **In Progress**: `accepted`, `in-progress`
- **Completed**: `delivery-confirmed`, `completed`
- **Cancelled**: `cancelled`, `rejected`
- **Revision**: `revision`
- **Delivery Requested**: `delivery-requested`

### 3. Payment Statuses
- **Due**: Payment pending
- **Paid**: Payment completed
- **Hold**: Payment on hold
- **Refunded**: Payment refunded

## Usage

### Controller
```dart
class OrdersController extends GetxController with GetTickerProviderStateMixin, OrderMixin {
  // Controller automatically loads orders on init
  // Use mixin methods for data operations
}
```

### Mixin Methods
```dart
// Get orders for specific tab
List<Order> orders = controller.getOrdersForTab('Pending', true);

// Get status display text
String statusText = controller.getStatusDisplayText('offered');

// Get status color
int color = controller.getStatusColor('offered');
```

### Service Methods
```dart
// Fetch all orders
await orderService.fetchVendorOrders();

// Update order status
await orderService.updateOrderStatus(orderId, 'accepted');

// Accept order
await orderService.acceptOrder(orderId);
```

## API Integration

The system is designed to work with the following API endpoints:

- **GET** `/v1/order/retrieve/all` - Fetch all orders
- **PATCH** `/v1/order/update/{id}/status` - Update order status
- **POST** `/v1/order/{id}/extension` - Request delivery extension

## Data Models

### OrderResponseModel
Complete API response structure with pagination metadata.

### Order
Individual order with all details including:
- Basic info (ID, order number, price, quantity)
- Status and payment information
- Delivery details and shipping address
- Design files and extension history
- Timestamps

## UI Components

### OrdersScreen
- Toggle between General and Custom orders
- Tabbed interface for different order statuses
- Responsive order cards with status indicators
- Pull-to-refresh functionality
- Loading and error states

### Order Cards
- Order ID and status badge
- Price, quantity, and type information
- Payment and delivery status
- Shipping address
- Order summary
- Action buttons

## Status Management

The system automatically categorizes orders based on their status:

- **Pending Tab**: Shows orders with `offered` or `pending` status
- **In Progress Tab**: Shows orders with `accepted` or `in-progress` status
- **Completed Tab**: Shows orders with `delivery-confirmed` or `completed` status
- **Cancelled Tab**: Shows orders with `cancelled` or `rejected` status

## Error Handling

- Network error handling with retry functionality
- Loading states for better UX
- User-friendly error messages
- Automatic data refresh on errors

## Future Enhancements

- Real-time order updates
- Push notifications for new orders
- Advanced filtering and search
- Order analytics and reporting
- Bulk order operations 