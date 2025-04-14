import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'portfolio_screen.dart';
import 'stock_price_screen.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Dashboard'),
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
            title: Text('Portfolio'),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PortfolioScreen()),
                ),
          ),
          ListTile(
            title: Text('Stock Prices'),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => StockPriceScreen()),
                ),
          ),
        ],
      ),
    );
  }
}
