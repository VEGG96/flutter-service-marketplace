import 'package:equatable/equatable.dart';

enum UserRole { client, provider }

extension UserRoleMapper on UserRole {
  static UserRole fromValue(String? value) {
    switch (value) {
      case 'provider':
        return UserRole.provider;
      case 'client':
      default:
        return UserRole.client;
    }
  }

  String get value {
    switch (this) {
      case UserRole.client:
        return 'client';
      case UserRole.provider:
        return 'provider';
    }
  }
}

class UserEntity extends Equatable {
  final String id;
  final String? email;
  final UserRole role;

  const UserEntity({required this.id, this.email, this.role = UserRole.client});

  @override
  List<Object?> get props => <Object?>[id, email, role];
}
