import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

abstract class AuthRepository {
  Stream<UserModel?> get currentUser;

  Future<void> signIn({required String email, required String password});

  Future<void> signUp({required String email, required String password});

  Future<void> signOut();
}

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthRepository({required FirebaseAuth firebaseAuth})
    : _firebaseAuth = firebaseAuth;

  @override
  Stream<UserModel?> get currentUser =>
      _firebaseAuth.authStateChanges().map((user) {
        if (user == null) return null;
        return UserModel(id: user.uid, email: user.email);
      });

  @override
  Future<void> signIn({required String email, required String password}) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signUp({required String email, required String password}) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
