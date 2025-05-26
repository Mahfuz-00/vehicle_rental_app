import '../Repositories/rental_repository.dart';
import '../Repositories/vehicle_repository.dart';

class StartRentalUseCase {
  final RentalRepository repository;

  StartRentalUseCase(this.repository);

  Future<String> call(String vehicleId) async {
    return await repository.startRental(vehicleId);
  }
}