# Payment Flow Documentation

## Overview
The payment system ensures that orders are **only created AFTER successful payment**. The system uses Stripe Checkout via WebView with proper session tracking.

---

## Payment Flow Sequence

### 1️⃣ **User Initiates Payment**
- User clicks "Payment" or "Accept Offer" button
- System validates amount (must be > $0.01)
- Loading dialog appears

### 2️⃣ **Payment Initialization** 
```
POST {{base-url}}/order/initiate-payment
Body: {
  "customerEmail": "user@example.com",
  "amount": 24.00,
  "currency": "USD",
  "quantity": 1
}
```

**Response:**
```json
{
  "status": "success",
  "data": {
    "url": "https://checkout.stripe.com/c/pay/cs_test_..."
  }
}
```

### 3️⃣ **WebView Payment Screen Opens**
- Shows Stripe Checkout page (branded with app colors)
- User completes payment on Stripe
- System monitors URL changes for success/cancel

### 4️⃣ **Payment Success Detection**
- Stripe redirects to success URL with session ID:
  ```
  http://yourserver.com/success?session_id=cs_test_a1AJxxDrHzzjzdGkkPKvlSeehRWwqKLue9OTm1vvvLYcELRfQVtm5Mw2Bd
  ```
- System extracts `session_id` from URL
- WebView closes and returns: `{success: true, sessionId: 'cs_test_...'}`

### 5️⃣ **Order Creation (ONLY AFTER PAYMENT SUCCESS)** ✅
```dart
if (!paymentCompleted) {
  // ❌ Payment not completed - ABORT order creation
  return;
}

// ✅ Payment successful - NOW create order
final isOrderSuccess = await createGeneralOrder(
  sessionId: sessionId, // Stripe session ID for verification
);
```

**API Call:**
```
POST {{base-url}}/general-order/create
Body: {
  "vendor": "68d7841730e1a910f96d25fc",
  "client": "683fe5292cc40200267ee234",
  "price": 24,
  "products": [{
    "productId": "68ac3ad78f1f43ba597d141e",
    "quantity": 2
  }],
  "paymentStatus": "paid",
  "shippingAddress": "Police Park, road 8, block d, Banasree",
  "sessionId": "cs_test_a13eSRoeKGPZaEYltELTY723LaZghkSWbxyWxrYzH3cKHUVdZji2IWvt43"
}
```

### 6️⃣ **Success Page Display**
- Shows `PaymentSuccessPage` with:
  - Amount paid
  - Transaction ID (session ID)
  - Success status
  - Order details

---

## Critical Security Features

### ✅ **Order Created ONLY After Payment**
```dart
// Step 1: Process payment
final paymentResult = await initiateAndProcessPayment();

// Step 2: Check payment status
if (!paymentCompleted) {
  return; // ❌ STOP - No order creation
}

// Step 3: Create order (only reached if payment succeeded)
await createGeneralOrder(sessionId: sessionId);
```

### ✅ **Session ID Verification**
- Backend can verify payment with Stripe using session ID
- Prevents fraudulent orders
- Ensures payment actually succeeded

### ✅ **Payment Status Tracking**
```dart
"paymentStatus": "paid"  // Hardcoded because order only created after payment
```

---

## Two Payment Scenarios

### Scenario A: General Order (New Product Purchase)
**File:** `order_overview_screen.dart`

**Flow:**
1. User selects product and quantity
2. Clicks "Payment" button
3. Payment processed via WebView
4. **Order created** with session ID
5. Success page shown

### Scenario B: Order Acceptance (Accepting Custom Design Offer)
**File:** `order_card_action_buttons.dart`

**Flow:**
1. User receives custom design offer
2. Clicks "Accept Offer" button
3. Payment processed via WebView
4. **Order status updated to "accepted"** with session ID
5. Success page shown

---

## Error Handling

### Payment Cancelled
- User clicks back or cancels payment
- WebView detects cancel URL
- Shows: "Payment was cancelled"
- **No order created** ❌

### Payment Failed
- Payment processing error
- WebView detects failure URL
- Shows error message
- **No order created** ❌

### Order Creation Failed (Payment Succeeded)
- Rare scenario: Payment succeeded but order creation failed
- Shows: "Payment succeeded but order creation failed"
- User should contact support
- Session ID can be used to verify payment and manually create order

---

## Debug Logs

### Payment Result
```
=== Payment Result ===
Payment completed: true
Session ID: cs_test_a1AJxxDrHzzjzdGkkPKvlSeehRWwqKLue9OTm1vvvLYcELRfQVtm5Mw2Bd
```

### Order Creation
```
✅ Payment successful - Creating order...
=== Creating General Order ===
Endpoint: general-order/create
Payload: {"vendor":"...","client":"...","sessionId":"cs_test_..."}
Response Status: 201
✅ Order created successfully
```

---

## Key Files

| File | Purpose |
|------|---------|
| `payment_service.dart` | Payment API integration |
| `payment_webview_screen.dart` | In-app Stripe checkout |
| `order_payment_controller.dart` | Payment flow management |
| `mixin_create_order.dart` | Order creation logic |
| `order_overview_screen.dart` | General order payment |
| `order_card_action_buttons.dart` | Order acceptance payment |

---

## Summary

✅ **Payment MUST succeed before order creation**  
✅ **Session ID extracted from Stripe success URL**  
✅ **Session ID sent to backend for verification**  
✅ **No order created if payment fails or is cancelled**  
✅ **Success page shown only after order creation**

This ensures **no unpaid orders** are created in the system! 🎉
