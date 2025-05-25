import '../Entities/vehicle_entity.dart';
import '../Repositories/vehicle_repository.dart';

class AddVehicleUseCase {
  final VehicleRepository repository;

  AddVehicleUseCase(this.repository);

  Future<void> execute(Vehicle vehicle) async {
    await repository.addVehicle(vehicle);
  }
}