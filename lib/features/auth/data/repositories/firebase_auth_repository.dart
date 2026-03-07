import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  FirebaseAuthRepository({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firebaseFirestore,
  }) : _firebaseAuth = firebaseAuth,
       _firebaseFirestore = firebaseFirestore;

  @override
  Stream<UserEntity?> get currentUser =>
      _firebaseAuth.authStateChanges().map((user) {
        if (user == null) return null;
        return UserModel(id: user.uid, email: user.email);
      });

  @override
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(FirebaseAuthErrorMessages.fromCode(e.code));
    } catch (_) {
      throw Exception(ApiErrorMessages.unknown);
    }
  }

  @override
  Future<void> signUp({required String email, required String password}) async {
    try {
      final UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final User? user = credential.user;
      if (user != null) {
        await _saveUserDocument(user);
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(FirebaseAuthErrorMessages.fromCode(e.code));
    } on FirebaseException catch (e) {
      throw Exception(_mapFirestoreError(e));
    } catch (_) {
      throw Exception(ApiErrorMessages.unknown);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (_) {
      throw Exception(ApiErrorMessages.unknown);
    }
  }

  Future<void> _saveUserDocument(User user) async {
    await _firebaseFirestore
        .collection(FirestoreCollections.users)
        .doc(user.uid)
        .set(<String, dynamic>{
          FirestoreFields.id: user.uid,
          FirestoreFields.email: user.email,
          FirestoreFields.createdAt: FieldValue.serverTimestamp(),
          FirestoreFields.updatedAt: FieldValue.serverTimestamp(),
          FirestoreFields.status: 'active',
        }, SetOptions(merge: true));
  }

  String _mapFirestoreError(FirebaseException exception) {
    switch (exception.code) {
      case 'permission-denied':
        return ApiErrorMessages.forbidden;
      case 'unavailable':
        return ApiErrorMessages.serviceUnavailable;
      case 'not-found':
        return ApiErrorMessages.notFound;
      case 'already-exists':
        return ApiErrorMessages.conflict;
      case 'unauthenticated':
        return ApiErrorMessages.unauthorized;
      default:
        return ApiErrorMessages.unknown;
    }
  }
}
