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
      _firebaseAuth.authStateChanges().asyncMap((user) async {
        if (user == null) return null;

        final UserRole role = await _resolveUserRole(user.uid);
        return UserModel(id: user.uid, email: user.email, role: role);
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

  @override
  Future<void> deleteAccount() async {
    try {
      final User? user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception(ApiErrorMessages.unauthorized);
      }

      await _firebaseFirestore
          .collection(FirestoreCollections.users)
          .doc(user.uid)
          .delete();
      await user.delete();
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw Exception(FirebaseAuthErrorMessages.fromCode(e.code));
    } on FirebaseException catch (e) {
      throw Exception(_mapFirestoreError(e));
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
          FirestoreFields.role: UserRole.client.value,
          FirestoreFields.createdAt: FieldValue.serverTimestamp(),
          FirestoreFields.updatedAt: FieldValue.serverTimestamp(),
          FirestoreFields.status: 'active',
        }, SetOptions(merge: true));
  }

  Future<UserRole> _resolveUserRole(String userId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firebaseFirestore
              .collection(FirestoreCollections.users)
              .doc(userId)
              .get();

      final Map<String, dynamic>? data = snapshot.data();
      return UserRoleMapper.fromValue(data?[FirestoreFields.role] as String?);
    } on FirebaseException {
      return UserRole.client;
    }
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
