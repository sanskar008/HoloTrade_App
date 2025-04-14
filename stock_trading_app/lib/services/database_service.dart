import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/stock.dart';
import '../models/transaction.dart';
import '../models/user_portfolio.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stock operations
  Stream<List<Stock>> getStocks() {
    return _firestore
        .collection('stocks')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Stock.fromMap(doc.data())).toList(),
        );
  }

  // Transaction operations
  Future<void> addTransaction(Transaction transaction) async {
    await _firestore
        .collection('transactions')
        .doc(transaction.id)
        .set(transaction.toMap());
  }

  Stream<List<Transaction>> getUserTransactions(String userId) {
    return _firestore
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => Transaction.fromMap(doc.data()))
                  .toList(),
        );
  }

  Stream<List<Transaction>> getAllTransactions() {
    return _firestore
        .collection('transactions')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => Transaction.fromMap(doc.data()))
                  .toList(),
        );
  }

  // Portfolio operations
  Stream<UserPortfolio> getPortfolio(String userId) {
    return _firestore
        .collection('portfolios')
        .doc(userId)
        .snapshots()
        .map((doc) => UserPortfolio.fromMap(doc.data()!));
  }

  Future<void> updatePortfolio(
    String userId,
    double balance,
    Map<String, int> stocks,
  ) async {
    await _firestore.collection('portfolios').doc(userId).update({
      'balance': balance,
      'stocks': stocks,
    });
  }

  Future<void> buyStockForUser(
    String userId,
    String stockId,
    int quantity,
    double price,
  ) async {
    DocumentSnapshot portfolioDoc =
        await _firestore.collection('portfolios').doc(userId).get();
    UserPortfolio portfolio = UserPortfolio.fromMap(
      portfolioDoc.data() as Map<String, dynamic>,
    );
    double cost = quantity * price;
    if (portfolio.balance >= cost) {
      portfolio.balance -= cost;
      portfolio.stocks[stockId] = (portfolio.stocks[stockId] ?? 0) + quantity;
      await updatePortfolio(userId, portfolio.balance, portfolio.stocks);
      await addTransaction(
        Transaction(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: userId,
          stockId: stockId,
          quantity: quantity,
          price: price,
          type: 'buy',
          timestamp: DateTime.now(),
        ),
      );
    }
  }
}
