import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/stock_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/user/user_dashboard.dart';
import 'screens/admin/admin_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

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
  } catch (e) {
    print('Firebase initialization error: $e');
  }

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
            // Show loading screen while checking authentication
            if (auth.currentUser == null && !auth.isAdmin) {
              return LoginScreen();
            }
            
            return auth.isAdmin
                ? AdminDashboard()
                : UserDashboard();
          },
        ),
      ),
    );
  }
}
