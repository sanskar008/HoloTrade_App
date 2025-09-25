import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_portfolio.dart';
import '../../models/transaction.dart' as app_transaction;
import '../../services/database_service.dart';
import '../../providers/auth_provider.dart';

class PortfolioScreen extends StatelessWidget {
  final DatabaseService _databaseService = DatabaseService();

  PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String? userId = context.read<AuthProvider>().currentUser?.uid;
    
    if (userId == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Portfolio')),
        body: Center(child: Text('User not authenticated')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Portfolio')),
      body: StreamBuilder<UserPortfolio>(
        stream: _databaseService.getPortfolio(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          UserPortfolio portfolio = snapshot.data!;
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Balance: ₹${portfolio.balance.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Expanded(
                child: StreamBuilder<List<app_transaction.Transaction>>(
                  stream: _databaseService.getUserTransactions(userId),
                  builder: (context, txSnapshot) {
                    if (!txSnapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    List<app_transaction.Transaction> transactions = txSnapshot.data!;
                    return ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        app_transaction.Transaction tx = transactions[index];
                        return ListTile(
                          title: Text('Stock: ${tx.stockId}'),
                          subtitle: Text(
                            '${tx.type.toUpperCase()}: ${tx.quantity} shares @ ₹${tx.price.toStringAsFixed(2)}',
                          ),
                          trailing: Text(tx.timestamp.toString()),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
