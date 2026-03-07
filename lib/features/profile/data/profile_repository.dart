import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_constants.dart';
import '../models/profile_model.dart';

abstract class ProfileRepository {
  Stream<ProfileModel> watchProfile();

  Future<void> saveProfile(ProfileModel profile);

  Future<void> uploadProfileImageFromGallery();
}

class FirebaseProfileRepository implements ProfileRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseStorage _firebaseStorage;
  final ImagePicker _imagePicker;

  FirebaseProfileRepository({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firebaseFirestore,
    required FirebaseStorage firebaseStorage,
    required ImagePicker imagePicker,
  }) : _firebaseAuth = firebaseAuth,
       _firebaseFirestore = firebaseFirestore,
       _firebaseStorage = firebaseStorage,
       _imagePicker = imagePicker;

  @override
  Stream<ProfileModel> watchProfile() {
    final User user = _currentUser();

    return _usersCollection.doc(user.uid).snapshots().map((snapshot) {
      final Map<String, dynamic>? data = snapshot.data();
      if (data == null) {
        return ProfileModel.empty(id: user.uid, email: user.email ?? '');
      }
      return ProfileModel.fromMap(user.uid, data);
    });
  }

  @override
  Future<void> saveProfile(ProfileModel profile) async {
    final User user = _currentUser();

    try {
      await _usersCollection.doc(user.uid).set(<String, dynamic>{
        ...profile.toMap(),
        FirestoreFields.updatedAt: FieldValue.serverTimestamp(),
        FirestoreFields.createdAt: profile.createdAt == null
            ? FieldValue.serverTimestamp()
            : Timestamp.fromDate(profile.createdAt!),
      }, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      throw Exception(_mapFirestoreError(e));
    } catch (_) {
      throw Exception(ApiErrorMessages.unknown);
    }
  }

  @override
  Future<void> uploadProfileImageFromGallery() async {
    final User user = _currentUser();

    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 82,
        maxWidth: 1280,
      );
      if (image == null) return;

      final Reference ref = _firebaseStorage.ref(
        'users/${user.uid}/profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await ref.putData(
        await image.readAsBytes(),
        SettableMetadata(contentType: 'image/jpeg'),
      );

      final String imageUrl = await ref.getDownloadURL();
      await _usersCollection.doc(user.uid).set(<String, dynamic>{
        FirestoreFields.id: user.uid,
        FirestoreFields.email: user.email,
        FirestoreFields.profileImageUrl: imageUrl,
        FirestoreFields.updatedAt: FieldValue.serverTimestamp(),
        FirestoreFields.createdAt: FieldValue.serverTimestamp(),
        FirestoreFields.status: 'active',
      }, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      throw Exception(_mapStorageOrFirestoreError(e));
    } catch (_) {
      throw Exception(ApiErrorMessages.unknown);
    }
  }

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firebaseFirestore.collection(FirestoreCollections.users);

  User _currentUser() {
    final User? user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception(ApiErrorMessages.unauthorized);
    }
    return user;
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

  String _mapStorageOrFirestoreError(FirebaseException exception) {
    switch (exception.code) {
      case 'permission-denied':
      case 'unauthorized':
        return ApiErrorMessages.forbidden;
      case 'object-not-found':
      case 'not-found':
        return ApiErrorMessages.notFound;
      case 'quota-exceeded':
      case 'resource-exhausted':
        return ApiErrorMessages.tooManyRequests;
      case 'cancelled':
        return ApiErrorMessages.requestCancelled;
      case 'unavailable':
        return ApiErrorMessages.serviceUnavailable;
      default:
        return ApiErrorMessages.unknown;
    }
  }
}
