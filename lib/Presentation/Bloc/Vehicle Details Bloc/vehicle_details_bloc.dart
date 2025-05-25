import 'package:flutter_bloc/flutter_bloc.dart';
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
        final message = await startRentalUseCase.execute(event.vehicleId);
        emit(VehicleDetailRentalStarted(message));
      } catch (e) {
        emit(VehicleDetailError(e.toString()));
      }
    });
  }
}