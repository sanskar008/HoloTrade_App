class Transaction {
  final String id;
  final String userId;
  final String stockId;
  final int quantity;
  final double price;
  final String type; // 'buy' or 'sell'
  final DateTime timestamp;

  Transaction({
    required this.id,
    required this.userId,
    required this.stockId,
    required this.quantity,
    required this.price,
    required this.type,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'stockId': stockId,
      'quantity': quantity,
      'price': price,
      'type': type,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      userId: map['userId'],
      stockId: map['stockId'],
      quantity: map['quantity'],
      price: map['price'],
      type: map['type'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}