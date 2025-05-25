import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Domain/Usecases/get_vehicle_usecase.dart';
import 'vehicle_list_event.dart';
import 'vehicle_list_state.dart';

class VehicleListBloc extends Bloc<VehicleListEvent, VehicleListState> {
  final GetVehiclesUseCase getVehiclesUseCase;

  VehicleListBloc(this.getVehiclesUseCase) : super(VehicleListInitial()) {
    on<FetchVehicles>((event, emit) async {
      emit(VehicleListLoading());
      try {
        final vehicles = await getVehiclesUseCase.execute();
        emit(VehicleListLoaded(vehicles));
      } catch (e) {
        emit(VehicleListError(e.toString()));
      }
    });
  }
}