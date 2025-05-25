import '../../Domain/Entities/profile_entity.dart';
import '../../Domain/Repositories/profile_repository.dart';
import '../Source/local_source.dart';
import '../Source/remote_source.dart';
import '../model/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;

  ProfileRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Profile> getProfile() async {
    try {
      final profileModel = await remoteDataSource.getProfile();
      await localDataSource.cacheProfile(profileModel);
      return profileModel.toEntity();
    } catch (e) {
      final cachedProfile = await localDataSource.getCachedProfile();
      if (cachedProfile != null) {
        return cachedProfile.toEntity();
      }
      throw Exception('Failed to load profile: $e');
    }
  }
}

extension ProfileModelExtension on ProfileModel {
  Profile toEntity() {
    return Profile(name: name, email: email, totalTrips: totalTrips);
  }
}