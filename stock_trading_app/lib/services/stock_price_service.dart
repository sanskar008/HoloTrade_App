import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/stock.dart';

class StockPriceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Timer? _timer;
  static const double drift = 0.00006944; // 5% over 1 hour
  static const double volatility = 0.00745; // 20% annualized
  static const double lambda = 0.005; // Sensitivity
  static const int baselineVolume = 100;

  void startPriceSimulation() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      QuerySnapshot stockSnapshot = await _firestore.collection('stocks').get();
      for (var doc in stockSnapshot.docs) {
        Stock stock = Stock.fromMap(doc.data() as Map<String, dynamic>);
        double newPrice = await _calculateNewPrice(stock);
        await _firestore.collection('stocks').doc(stock.id).update({
          'price': newPrice,
        });
      }
    });
  }

  Future<double> _calculateNewPrice(Stock stock) async {
    // GBM component
    double gbmChange = drift + volatility * (Random().nextDouble() * 2 - 1);

    // Market impact
    double marketImpact = await _calculateMarketImpact(stock.id);

    // Combine
    double totalChange = gbmChange + marketImpact;
    double newPrice = stock.price * (1 + totalChange);

    // Apply price floor
    return max(10.0, newPrice);
  }

  Future<double> _calculateMarketImpact(String stockId) async {
    DateTime now = DateTime.now();
    DateTime fiveSecondsAgo = now.subtract(Duration(seconds: 5));
    QuerySnapshot transactions =
        await _firestore
            .collection('transactions')
            .where('stockId', isEqualTo: stockId)
            .where(
              'timestamp',
              isGreaterThanOrEqualTo: fiveSecondsAgo.toIso8601String(),
            )
            .get();

    int buyVolume = 0;
    int sellVolume = 0;
    for (var doc in transactions.docs) {
      Transaction tx = Transaction.fromMap(doc.data() as Map<String, dynamic>);
      if (tx.type == 'buy') {
        buyVolume += tx.quantity;
      } else {
        sellVolume += tx.quantity;
      }
    }

    int netDemand = buyVolume - sellVolume;
    return lambda * (netDemand / baselineVolume);
  }

  void stopPriceSimulation() {
    _timer?.cancel();
  }
}
