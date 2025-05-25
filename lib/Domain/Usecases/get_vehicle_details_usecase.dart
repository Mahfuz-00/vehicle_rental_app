import '../Entities/vehicle_entity.dart';
import '../Repositories/vehicle_repository.dart';

class GetVehicleDetailsUseCase {
  final VehicleRepository repository;

  GetVehicleDetailsUseCase(this.repository);

  Future<Vehicle> execute(String id) async {
    return await repository.getVehicleDetails(id);
  }
}