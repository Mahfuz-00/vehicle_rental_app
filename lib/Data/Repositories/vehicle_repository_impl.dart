import '../../Domain/Entities/vehicle_entity.dart';
import '../../Domain/Repositories/vehicle_repository.dart';
import '../Source/local_source.dart';
import '../Source/remote_source.dart';
import '../Model/vehicle_model.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;

  VehicleRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<List<Vehicle>> getVehicles() async {
    try {
      final vehicleModels = await remoteDataSource.getVehicles();
      await localDataSource.cacheVehicles(vehicleModels);
      return vehicleModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      final cachedVehicles = await localDataSource.getCachedVehicles();
      if (cachedVehicles.isNotEmpty) {
        return cachedVehicles.map((model) => model.toEntity()).toList();
      }
      throw Exception('Failed to load vehicles: $e');
    }
  }

  @override
  Future<Vehicle> getVehicleDetails(String id) async {
    try {
      final vehicleModel = await remoteDataSource.getVehicleDetails(id);
      return vehicleModel.toEntity();
    } catch (e) {
      throw Exception('Failed to load vehicle details: $e');
    }
  }

  @override
  Future<String> startRental(String id) async {
    try {
      return await remoteDataSource.startRental(id);
    } catch (e) {
      throw Exception('Failed to start rental: $e');
    }
  }

  @override
  Future<void> addVehicle(Vehicle vehicle) async {
    try {
      final vehicleModel = VehicleModel.fromEntity(vehicle);
      await remoteDataSource.addVehicle(vehicleModel);
    } catch (e) {
      throw Exception('Failed to add vehicle: $e');
    }
  }
}