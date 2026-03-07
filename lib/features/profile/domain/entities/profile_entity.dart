import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
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

  const ProfileEntity({
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

  factory ProfileEntity.empty({required String id, required String email}) {
    return ProfileEntity(
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

  ProfileEntity copyWith({
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
    return ProfileEntity(
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
