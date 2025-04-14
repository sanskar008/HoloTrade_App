import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/stock.dart';
import '../../services/database_service.dart';
import '../../providers/stock_provider.dart';

class AdminStockManagement extends StatelessWidget {
  final DatabaseService _databaseService = DatabaseService();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  AdminStockManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stock Management')),
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
                trailing: IconButton(
                  icon: Icon(Icons.add_shopping_cart),
                  onPressed: () => _showBuyDialog(context, stock),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showBuyDialog(BuildContext context, Stock stock) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Buy ${stock.name} for User'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _userIdController,
                  decoration: InputDecoration(labelText: 'User ID'),
                ),
                TextField(
                  controller: _quantityController,
                  decoration: InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _databaseService.buyStockForUser(
                    _userIdController.text,
                    stock.id,
                    int.parse(_quantityController.text),
                    stock.price,
                  );
                  Navigator.pop(context);
                },
                child: Text('Buy'),
              ),
            ],
          ),
    );
  }
}
