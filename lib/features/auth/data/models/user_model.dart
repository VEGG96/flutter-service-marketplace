import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    super.email,
    super.role = UserRole.client,
  });
}
