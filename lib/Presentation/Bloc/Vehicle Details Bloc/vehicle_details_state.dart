import '../../../Domain/Entities/vehicle_entity.dart';

abstract class VehicleDetailState {}

class VehicleDetailInitial extends VehicleDetailState {}

class VehicleDetailLoading extends VehicleDetailState {}

class VehicleDetailLoaded extends VehicleDetailState {
  final Vehicle vehicle;

  VehicleDetailLoaded(this.vehicle);
}

class VehicleDetailRentalStarted extends VehicleDetailState {
  final String message;

  VehicleDetailRentalStarted(this.message);
}

class VehicleDetailError extends VehicleDetailState {
  final String message;

  VehicleDetailError(this.message);
}