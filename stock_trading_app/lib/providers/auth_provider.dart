import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isAdmin = false;

  bool get isAdmin => _isAdmin;
  
  // Expose auth service for accessing current user
  AuthService get authService => _authService;
  
  // Get current user directly
  User? get currentUser => _authService.auth.currentUser;

  Future<void> signIn(String email, String password) async {
    await _authService.signIn(email, password);
    if (_authService.auth.currentUser != null) {
      _isAdmin = await _authService.isAdmin(_authService.auth.currentUser!.uid);
    }
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
