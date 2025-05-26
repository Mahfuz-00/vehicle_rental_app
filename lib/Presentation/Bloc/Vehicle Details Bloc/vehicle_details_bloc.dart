import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Data/Model/vehicle_model.dart';
import '../../../Domain/Entities/vehicle_entity.dart';
import '../../../Domain/Usecases/get_vehicle_details_usecase.dart';
import '../../../Domain/Usecases/start_rental_usecase.dart';
import 'vehicle_details_event.dart';
import 'vehicle_details_state.dart';


class VehicleDetailBloc extends Bloc<VehicleDetailEvent, VehicleDetailState> {
  final GetVehicleDetailsUseCase getVehicleDetailsUseCase;
  final StartRentalUseCase startRentalUseCase;

  VehicleDetailBloc(this.getVehicleDetailsUseCase, this.startRentalUseCase) : super(VehicleDetailInitial()) {
    on<FetchVehicleDetails>((event, emit) async {
      emit(VehicleDetailLoading());
      try {
        final vehicle = await getVehicleDetailsUseCase.execute(event.vehicleId);
        emit(VehicleDetailLoaded(vehicle));
      } catch (e) {
        emit(VehicleDetailError(e.toString()));
      }
    });

    on<StartRental>((event, emit) async {
      try {
        // Get current state to access vehicle
        final currentState = state;
        if (currentState is VehicleDetailLoaded) {
          final message = await startRentalUseCase(event.vehicleId);
          // Create updated vehicle with unavailable status
          final updatedVehicle = Vehicle(
            id: currentState.vehicle.id,
            name: currentState.vehicle.name,
            type: currentState.vehicle.type,
            status: 'unavailable', // Update status
            image: currentState.vehicle.image,
            battery: currentState.vehicle.battery,
            location: currentState.vehicle.location,
            costPerMinute: currentState.vehicle.costPerMinute,
          );

          print('Updated: ${updatedVehicle.name} ${updatedVehicle.status}');
          // Emit updated loaded state
          emit(VehicleDetailLoaded(updatedVehicle));

          await Future.delayed(const Duration(milliseconds: 500));
          // Emit rental started state
          emit(VehicleDetailRentalStarted(message));
        } else {
          throw Exception('Vehicle details not loaded');
        }
      } catch (error) {
        emit(VehicleDetailError(error.toString()));
      }
    });
  }
}