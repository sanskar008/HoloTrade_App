import 'package:flutter/material.dart';
import '../../models/transaction.dart';
import '../../services/database_service.dart';

class AdminUserTransactions extends StatelessWidget {
  final DatabaseService _databaseService = DatabaseService();

  AdminUserTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Transactions')),
      body: StreamBuilder<List<Transaction>>(
        stream: _databaseService.getAllTransactions(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          List<Transaction> transactions = snapshot.data!;
          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              Transaction tx = transactions[index];
              return ListTile(
                title: Text('User: ${tx.userId} | Stock: ${tx.stockId}'),
                subtitle: Text(
                  '${tx.type.toUpperCase()}: ${tx.quantity} shares @ ₹${tx.price.toStringAsFixed(2)}',
                ),
                trailing: Text(tx.timestamp.toString()),
              );
            },
          );
        },
      ),
    );
  }
}
