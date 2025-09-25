import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User?> register(String email, String password, bool isAdmin) async {
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _firestore.collection('users').doc(result.user!.uid).set({
        'email': email,
        'isAdmin': isAdmin,
        'createdAt': FieldValue.serverTimestamp(),
      });
      // Initialize portfolio
      await _firestore.collection('portfolios').doc(result.user!.uid).set({
        'userId': result.user!.uid,
        'balance': 100000.0, // Starting balance
        'stocks': {},
      });
      return result.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> isAdmin(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    return doc['isAdmin'] ?? false;
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}
