class WalletResponse {
  final int statusCode;
  final String status;
  final String message;
  final WalletData data;

  WalletResponse({
    required this.statusCode,
    required this.status,
    required this.message,
    required this.data,
  });

  factory WalletResponse.fromJson(Map<String, dynamic> json) => WalletResponse(
        statusCode: json['statusCode'],
        status: json['status'],
        message: json['message'],
        data: WalletData.fromJson(json['data']),
      );

  get balance => null;

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'status': status,
        'message': message,
        'data': data.toJson(),
      };
}

class WalletData {
  final Balance balance;
  final String id;
  final List<TransactionHistory> transactionHistory;
  final DateTime updatedAt;

  WalletData({
    required this.balance,
    required this.id,
    required this.transactionHistory,
    required this.updatedAt,
  });

  factory WalletData.fromJson(Map<String, dynamic> json) => WalletData(
        balance: Balance.fromJson(json['balance']),
        id: json['_id'],
        transactionHistory: List<TransactionHistory>.from(
            json['transactionHistory'].map((x) => TransactionHistory.fromJson(x))),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  Map<String, dynamic> toJson() => {
        'balance': balance.toJson(),
        '_id': id,
        'transactionHistory':
            transactionHistory.map((x) => x.toJson()).toList(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

class Balance {
  final String currency;
  final double amount;

  Balance({
    required this.currency,
    required this.amount,
  });

  factory Balance.fromJson(Map<String, dynamic> json) => Balance(
        currency: json['currency'] ?? '',
        amount: (json['amount'] ?? 0.0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'currency': currency,
        'amount': amount,
      };
}

class TransactionHistory {
  final double amount;
  final String type;
  final DateTime transactionAt;
  final String id;

  TransactionHistory({
    required this.amount,
    required this.type,
    required this.transactionAt,
    required this.id,
  });

  factory TransactionHistory.fromJson(Map<String, dynamic> json) =>
      TransactionHistory(
        amount: (json['amount'] ?? 0.0).toDouble(),
        type: json['type'] ?? '',
        transactionAt: DateTime.parse(json['transactionAt']),
        id: json['_id'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'type': type,
        'transactionAt': transactionAt.toIso8601String(),
        '_id': id,
      };
}
