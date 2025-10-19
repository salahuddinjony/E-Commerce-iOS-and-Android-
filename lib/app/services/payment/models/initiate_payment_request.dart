class InitiatePaymentRequest {
  final String customerEmail;
  final double amount;
  final String currency;
  final int quantity;

  InitiatePaymentRequest({
    required this.customerEmail,
    required this.amount,
    required this.currency,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'customerEmail': customerEmail,
      'amount': amount,
      'currency': currency,
      'quantity': quantity,
    };
  }
}
