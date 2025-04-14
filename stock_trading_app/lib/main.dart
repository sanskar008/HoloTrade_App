import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'providers/auth_provider.dart';
import 'providers/stock_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/user/user_dashboard.dart';
import 'screens/admin/admin_dashboard.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize some stocks for testing
  await FirebaseFirestore.instance.collection('stocks').doc('TATA').set({
    'id': 'TATA',
    'name': 'Tata Motors',
    'price': 100.0,
    'initialPrice': 100.0,
  });
  await FirebaseFirestore.instance.collection('stocks').doc('RELIANCE').set({
    'id': 'RELIANCE',
    'name': 'Reliance Industries',
    'price': 200.0,
    'initialPrice': 200.0,
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => StockProvider()),
      ],
      child: MaterialApp(
        title: 'Stock Trading App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            return auth.isAdmin
                ? AdminDashboard()
                : (auth.authService.auth.currentUser != null
                    ? UserDashboard()
                    : LoginScreen());
          },
        ),
      ),
    );
  }
}
