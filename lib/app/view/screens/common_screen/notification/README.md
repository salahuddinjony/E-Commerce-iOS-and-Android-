# Notification System Implementation

This directory contains the complete notification system implementation for the U-Tee Hub app.

## Structure

```
notification/
├── controller/
│   └── notification_controller.dart    # Main controller using NotificationMixin
├── mixin/
│   └── notification_mixin.dart         # API calls and state management
├── model/
│   └── notification_model.dart         # Data models for notifications
└── README.md                           # This documentation
```

## Features

### 1. Get Notifications
- **API Endpoint**: `GET {{base-url}}/notification/retrive/consumer/{consumerId}`
- **Response**: List of notifications with content, timestamps, and dismissal status
- **Usage**: Automatically loads when controller initializes

### 2. Dismiss Individual Notification
- **API Endpoint**: `PATCH {{base-url}}/notification/dismiss/{notificationId}`
- **Response**: Success message
- **Usage**: Tap the close icon on any notification item

### 3. Clear All Notifications
- **API Endpoint**: `DELETE {{base-url}}/notification/clear/consumer/{consumerId}`
- **Response**: Success message
- **Usage**: Tap the floating action button (clear all icon)

## Models

### NotificationModel
Main response model containing:
- `statusCode`: HTTP status code
- `status`: Response status
- `message`: Response message
- `data`: List of NotificationData objects

### NotificationData
Individual notification data:
- `content`: NotificationContent object
- `id`: Unique notification ID
- `consumer`: Consumer ID
- `isDismissed`: Dismissal status
- `createdAt`: Creation timestamp
- `updatedAt`: Last update timestamp

### NotificationContent
Notification content:
- `source`: Source information (type)
- `title`: Notification title
- `message`: Notification message

## Controller

### NotificationController
Extends `GetxController` and uses `NotificationMixin`:
- Automatically loads notifications on initialization
- Provides methods for refreshing, dismissing, and clearing notifications
- Manages loading states and error handling

## Mixin

### NotificationMixin
Contains all API call logic:
- `getNotifications()`: Fetch notifications from API
- `dismissNotification()`: Dismiss individual notification
- `clearAllNotifications()`: Clear all notifications
- State management with Rx variables

## UI Features

### NotificationScreen
- **Loading State**: Shows custom loader while fetching data
- **Error State**: Shows error screen with retry option
- **Empty State**: Shows friendly message when no notifications
- **List View**: Displays notifications with dismiss option
- **Floating Action Button**: Clear all notifications (only visible when notifications exist)
- **Confirmation Dialogs**: Confirms dismiss and clear actions

## Usage

1. **Dependency Injection**: Controller is automatically injected via `DependencyInjection`
2. **Navigation**: Navigate to `NotificationScreen` using route `RoutePath.notificationScreen`
3. **Consumer ID**: Currently hardcoded to `"684d19381e5cb9958084f4fd"` - should be updated to use actual user ID from authentication

## API Endpoints

```dart
// Get notifications
static String getNotifications({required String consumerId}) {
  return "/notification/retrive/consumer/$consumerId";
}

// Dismiss notification
static String dismissNotification({required String notificationId}) {
  return "/notification/dismiss/$notificationId";
}

// Clear all notifications
static String clearAllNotifications({required String consumerId}) {
  return "/notification/clear/consumer/$consumerId";
}
```

## Future Improvements

1. **User ID Integration**: Replace hardcoded consumer ID with actual user ID from authentication
2. **Real-time Updates**: Implement WebSocket or polling for real-time notifications
3. **Push Notifications**: Add push notification support
4. **Notification Categories**: Support for different notification types
5. **Pagination**: Handle large numbers of notifications with pagination
6. **Offline Support**: Cache notifications for offline viewing
