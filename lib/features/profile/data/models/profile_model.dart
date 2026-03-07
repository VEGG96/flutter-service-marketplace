import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.email,
    required super.fullName,
    required super.businessName,
    required super.phone,
    required super.city,
    required super.address,
    required super.bio,
    required super.profileImageUrl,
    super.createdAt,
    super.updatedAt,
  });

  factory ProfileModel.empty({required String id, required String email}) {
    return ProfileModel(
      id: id,
      email: email,
      fullName: '',
      businessName: '',
      phone: '',
      city: '',
      address: '',
      bio: '',
      profileImageUrl: '',
    );
  }

  factory ProfileModel.fromMap(String id, Map<String, dynamic> data) {
    return ProfileModel(
      id: id,
      email: (data[FirestoreFields.email] as String?) ?? '',
      fullName: (data[FirestoreFields.fullName] as String?) ?? '',
      businessName: (data[FirestoreFields.businessName] as String?) ?? '',
      phone: (data[FirestoreFields.phone] as String?) ?? '',
      city: (data[FirestoreFields.city] as String?) ?? '',
      address: (data[FirestoreFields.address] as String?) ?? '',
      bio: (data[FirestoreFields.bio] as String?) ?? '',
      profileImageUrl: (data[FirestoreFields.profileImageUrl] as String?) ?? '',
      createdAt: _parseTimestamp(data[FirestoreFields.createdAt]),
      updatedAt: _parseTimestamp(data[FirestoreFields.updatedAt]),
    );
  }

  factory ProfileModel.fromEntity(ProfileEntity profile) {
    return ProfileModel(
      id: profile.id,
      email: profile.email,
      fullName: profile.fullName,
      businessName: profile.businessName,
      phone: profile.phone,
      city: profile.city,
      address: profile.address,
      bio: profile.bio,
      profileImageUrl: profile.profileImageUrl,
      createdAt: profile.createdAt,
      updatedAt: profile.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      FirestoreFields.id: id,
      FirestoreFields.email: email,
      FirestoreFields.fullName: fullName,
      FirestoreFields.businessName: businessName,
      FirestoreFields.phone: phone,
      FirestoreFields.city: city,
      FirestoreFields.address: address,
      FirestoreFields.bio: bio,
      FirestoreFields.profileImageUrl: profileImageUrl,
      FirestoreFields.status: 'active',
    };
  }

  static DateTime? _parseTimestamp(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }
}
