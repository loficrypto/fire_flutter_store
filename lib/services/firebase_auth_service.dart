import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get onAuthStateChanged => _firebaseAuth.authStateChanges();

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    final UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  }

  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    final UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
