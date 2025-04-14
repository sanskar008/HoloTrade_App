class UserPortfolio {
  final String userId;
  double balance;
  final Map<String, int> stocks; // stockId: quantity

  UserPortfolio({
    required this.userId,
    required this.balance,
    required this.stocks,
  });

  Map<String, dynamic> toMap() {
    return {'userId': userId, 'balance': balance, 'stocks': stocks};
  }

  factory UserPortfolio.fromMap(Map<String, dynamic> map) {
    return UserPortfolio(
      userId: map['userId'],
      balance: map['balance'],
      stocks: Map<String, int>.from(map['stocks'] ?? {}),
    );
  }
}
