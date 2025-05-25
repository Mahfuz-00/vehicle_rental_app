import '../Repositories/vehicle_repository.dart';

class StartRentalUseCase {
  final VehicleRepository repository;

  StartRentalUseCase(this.repository);

  Future<String> execute(String id) async {
    return await repository.startRental(id);
  }
}