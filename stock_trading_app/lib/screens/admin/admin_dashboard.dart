import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'admin_stock_management.dart';
import 'admin_user_transactions.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => context.read<AuthProvider>().signOut(),
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Stock Management'),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AdminStockManagement()),
                ),
          ),
          ListTile(
            title: Text('User Transactions'),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AdminUserTransactions()),
                ),
          ),
        ],
      ),
    );
  }
}
