import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../../core/constants/app_constants.dart';

class ProfileModel extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String businessName;
  final String phone;
  final String city;
  final String address;
  final String bio;
  final String profileImageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProfileModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.businessName,
    required this.phone,
    required this.city,
    required this.address,
    required this.bio,
    required this.profileImageUrl,
    this.createdAt,
    this.updatedAt,
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

  ProfileModel copyWith({
    String? email,
    String? fullName,
    String? businessName,
    String? phone,
    String? city,
    String? address,
    String? bio,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProfileModel(
      id: id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      businessName: businessName ?? this.businessName,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      address: address ?? this.address,
      bio: bio ?? this.bio,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get initials {
    if (fullName.trim().isEmpty) return 'U';
    final List<String> parts = fullName.trim().split(' ');
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    final String first = parts[0].substring(0, 1).toUpperCase();
    final String last = parts[1].substring(0, 1).toUpperCase();
    return '$first$last';
  }

  static DateTime? _parseTimestamp(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
  }

  @override
  List<Object?> get props => <Object?>[
    id,
    email,
    fullName,
    businessName,
    phone,
    city,
    address,
    bio,
    profileImageUrl,
    createdAt,
    updatedAt,
  ];
}
