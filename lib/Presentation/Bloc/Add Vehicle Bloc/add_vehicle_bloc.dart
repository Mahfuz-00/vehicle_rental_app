import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Domain/Entities/vehicle_entity.dart';
import '../../../Domain/Usecases/add_vehicle_usecase.dart';
import 'add_vehicle_event.dart';
import 'add_vehicle_state.dart';

class AddVehicleBloc extends Bloc<AddVehicleEvent, AddVehicleState> {
  final AddVehicleUseCase addVehicleUseCase;

  AddVehicleBloc(this.addVehicleUseCase) : super(AddVehicleInitial()) {
    on<AddVehicleSubmitted>((event, emit) async {
      emit(AddVehicleLoading());
      try {
        final vehicle = Vehicle(
          id: event.id,
          name: event.name,
          type: event.type,
          status: event.status,
          image: event.image,
          battery: event.battery,
          location: {'lat': event.lat, 'lng': event.lng},
          costPerMinute: event.costPerMinute,
        );
        await addVehicleUseCase.execute(vehicle);
        emit(AddVehicleSuccess());
      } catch (e) {
        emit(AddVehicleError(e.toString()));
      }
    });
  }
}