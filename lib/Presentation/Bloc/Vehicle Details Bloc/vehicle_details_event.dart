abstract class VehicleDetailEvent {}

class FetchVehicleDetails extends VehicleDetailEvent {
  final String vehicleId;

  FetchVehicleDetails(this.vehicleId);
}

class StartRental extends VehicleDetailEvent {
  final String vehicleId;

  StartRental(this.vehicleId);
}