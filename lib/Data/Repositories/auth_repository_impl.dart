import '../../Domain/Entities/user_entity.dart';
import '../../Domain/Repositories/auth_repository.dart';
import '../Source/local_source.dart';
import '../Source/remote_source.dart';


class AuthRepositoryImpl implements AuthRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;

  AuthRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<User> login(String email, String password) async {
    try {
      final userModel = await remoteDataSource.login(email, password);
      await localDataSource.saveToken(userModel.token);
      await localDataSource.setRememberMe(true); // Assuming remember me is enabled
      return userModel.toEntity();
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await localDataSource.clear();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }
}