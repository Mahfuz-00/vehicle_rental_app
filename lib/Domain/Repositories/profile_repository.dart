import '../Entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<Profile> getProfile();
}