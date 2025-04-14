import 'package:flutter/material.dart';
import '../../models/user_portfolio.dart';
import '../../models/transaction.dart';
import '../../services/database_service.dart';

class PortfolioScreen extends StatelessWidget {
  final DatabaseService _databaseService = DatabaseService();

  PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String userId =
        context.read<AuthProvider>()._authService._auth.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: Text('Portfolio')),
      body: StreamBuilder<UserPortfolio>(
        stream: _databaseService.getPortfolio(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
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
                child: StreamBuilder<List<Transaction>>(
                  stream: _databaseService.getUserTransactions(userId),
                  builder: (context, txSnapshot) {
                    if (!txSnapshot.hasData)
                      return Center(child: CircularProgressIndicator());
                    List<Transaction> transactions = txSnapshot.data!;
                    return ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        Transaction tx = transactions[index];
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
