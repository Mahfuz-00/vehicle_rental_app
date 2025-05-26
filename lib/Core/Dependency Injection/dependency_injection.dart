import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import '../../Data/Repositories/auth_repository_impl.dart';
import '../../Data/Repositories/profile_repository_impl.dart';
import '../../Data/Repositories/rental_repository_impl.dart';
import '../../Data/Repositories/vehicle_repository_impl.dart';
import '../../Data/Source/local_source.dart';
import '../../Data/Source/remote_source.dart';
import '../../Domain/Repositories/auth_repository.dart';
import '../../Domain/Repositories/profile_repository.dart';
import '../../Domain/Repositories/rental_repository.dart';
import '../../Domain/Repositories/vehicle_repository.dart';
import '../../Domain/Usecases/add_vehicle_usecase.dart';
import '../../Domain/Usecases/get_profile_usecase.dart';
import '../../Domain/Usecases/get_vehicle_details_usecase.dart';
import '../../Domain/Usecases/get_vehicle_usecase.dart';
import '../../Domain/Usecases/log_out_usecase.dart';
import '../../Domain/Usecases/login_usecase.dart';
import '../../Domain/Usecases/start_rental_usecase.dart';
import '../../Presentation/Bloc/Vehicle Details Bloc/vehicle_details_bloc.dart';

final getIt = GetIt.instance;

void setupDi() {
  // Register HTTP client
  getIt.registerSingleton<http.Client>(http.Client());

  // Register data sources
  getIt.registerSingleton<LocalDataSource>(LocalDataSource());
  getIt.registerSingleton<RemoteDataSource>(RemoteDataSource());

  // Register repositories
  getIt.registerSingleton<AuthRepository>(AuthRepositoryImpl(getIt<RemoteDataSource>(), getIt<LocalDataSource>()));
  getIt.registerSingleton<VehicleRepository>(VehicleRepositoryImpl(getIt<RemoteDataSource>(), getIt<LocalDataSource>()));
  getIt.registerSingleton<ProfileRepository>(ProfileRepositoryImpl(getIt<RemoteDataSource>(), getIt<LocalDataSource>()));
  getIt.registerLazySingleton<RentalRepository>(
        () => RentalRepositoryImpl(getIt<RemoteDataSource>()),
  );

  // Register use cases
  getIt.registerSingleton<LoginUseCase>(LoginUseCase(getIt<AuthRepository>()));
  getIt.registerSingleton<GetVehiclesUseCase>(GetVehiclesUseCase(getIt<VehicleRepository>()));
  getIt.registerSingleton<GetVehicleDetailsUseCase>(GetVehicleDetailsUseCase(getIt<VehicleRepository>()));
  getIt.registerSingleton<AddVehicleUseCase>(AddVehicleUseCase(getIt<VehicleRepository>()));
  getIt.registerSingleton<GetProfileUseCase>(GetProfileUseCase(getIt<ProfileRepository>()));
  getIt.registerSingleton<LogoutUseCase>(LogoutUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton<StartRentalUseCase>(
        () => StartRentalUseCase(getIt<RentalRepository>()),
  );


  getIt.registerFactory<VehicleDetailBloc>(
        () => VehicleDetailBloc(
      getIt<GetVehicleDetailsUseCase>(),
      getIt<StartRentalUseCase>(),
    ),
  );
}