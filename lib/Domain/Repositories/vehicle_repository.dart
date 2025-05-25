import '../Entities/vehicle_entity.dart';

abstract class VehicleRepository {
  Future<List<Vehicle>> getVehicles();
  Future<Vehicle> getVehicleDetails(String id);
  Future<String> startRental(String id);
  Future<void> addVehicle(Vehicle vehicle);
}