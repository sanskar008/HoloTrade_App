import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isAdmin = false;

  var authService;

  bool get isAdmin => _isAdmin;

  Future<void> signIn(String email, String password) async {
    await _authService.signIn(email, password);
    _isAdmin = await _authService.isAdmin(_authService._auth.currentUser!.uid);
    notifyListeners();
  }

  Future<void> register(String email, String password, bool isAdmin) async {
    await _authService.register(email, password, isAdmin);
    _isAdmin = isAdmin;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _isAdmin = false;
    notifyListeners();
  }
}
