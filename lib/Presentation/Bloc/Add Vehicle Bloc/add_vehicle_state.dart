abstract class AddVehicleState {}

class AddVehicleInitial extends AddVehicleState {}

class AddVehicleLoading extends AddVehicleState {}

class AddVehicleSuccess extends AddVehicleState {}

class AddVehicleError extends AddVehicleState {
  final String message;

  AddVehicleError(this.message);
}