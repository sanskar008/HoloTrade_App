import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/stock.dart';
import '../../providers/stock_provider.dart';

class StockPriceScreen extends StatelessWidget {
  const StockPriceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stock Prices')),
      body: Consumer<StockProvider>(
        builder: (context, stockProvider, _) {
          List<Stock> stocks = stockProvider.stocks;
          if (stocks.isEmpty) return Center(child: CircularProgressIndicator());
          return ListView.builder(
            itemCount: stocks.length,
            itemBuilder: (context, index) {
              Stock stock = stocks[index];
              return ListTile(
                title: Text(stock.name),
                subtitle: Text('Price: ₹${stock.price.toStringAsFixed(2)}'),
              );
            },
          );
        },
      ),
    );
  }
}
