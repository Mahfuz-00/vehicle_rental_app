import '../../../Domain/Entities/vehicle_entity.dart';

abstract class VehicleListState {}

class VehicleListInitial extends VehicleListState {}

class VehicleListLoading extends VehicleListState {}

class VehicleListLoaded extends VehicleListState {
  final List<Vehicle> vehicles;

  VehicleListLoaded(this.vehicles);
}

class VehicleListError extends VehicleListState {
  final String message;

  VehicleListError(this.message);
}