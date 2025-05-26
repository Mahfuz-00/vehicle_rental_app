import '../../Domain/Repositories/rental_repository.dart';
import '../Source/remote_source.dart';

class RentalRepositoryImpl implements RentalRepository {
  final RemoteDataSource remoteDataSource;

  RentalRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> startRental(String id) async {
    return await remoteDataSource.startRental(id);
  }
}