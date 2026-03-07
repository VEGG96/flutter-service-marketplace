import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Stream<ProfileEntity> watchProfile();

  Future<void> saveProfile(ProfileEntity profile);

  Future<void> uploadProfileImageFromGallery();
}
