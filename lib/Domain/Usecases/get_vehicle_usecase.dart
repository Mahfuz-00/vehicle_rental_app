import '../Entities/vehicle_entity.dart';
import '../Repositories/vehicle_repository.dart';

class GetVehiclesUseCase {
  final VehicleRepository repository;

  GetVehiclesUseCase(this.repository);

  Future<List<Vehicle>> execute() async {
    return await repository.getVehicles();
  }
}