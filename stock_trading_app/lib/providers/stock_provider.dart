import 'package:flutter/material.dart';
import '../models/stock.dart';
import '../services/database_service.dart';
import '../services/stock_price_service.dart';

class StockProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final StockPriceService _stockPriceService = StockPriceService();
  List<Stock> _stocks = [];

  List<Stock> get stocks => _stocks;

  StockProvider() {
    _stockPriceService.startPriceSimulation();
    _databaseService.getStocks().listen((stocks) {
      _stocks = stocks;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _stockPriceService.stopPriceSimulation();
    super.dispose();
  }
}