import '../Entities/profile_entity.dart';
import '../Repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<Profile> execute() async {
    return await repository.getProfile();
  }
}