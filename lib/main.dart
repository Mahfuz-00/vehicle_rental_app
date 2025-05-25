import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Core/Dependency Injection/dependency_injection.dart';
import 'Core/Navigation/app_router.dart';
import 'Domain/Usecases/add_vehicle_usecase.dart';
import 'Domain/Usecases/get_profile_usecase.dart';
import 'Domain/Usecases/get_vehicle_details_usecase.dart';
import 'Domain/Usecases/get_vehicle_usecase.dart';
import 'Domain/Usecases/log_out_usecase.dart';
import 'Domain/Usecases/login_usecase.dart';
import 'Domain/Usecases/start_rental_usecase.dart';
import 'Presentation/Bloc/Add Vehicle Bloc/add_vehicle_bloc.dart';
import 'Presentation/Bloc/Login Bloc/login_bloc.dart';
import 'Presentation/Bloc/Profile Bloc/profile_bloc.dart';
import 'Presentation/Bloc/Profile Bloc/profile_event.dart';
import 'Presentation/Bloc/Vehicle Details Bloc/vehicle_details_bloc.dart';
import 'Presentation/Bloc/Vehicle List Bloc/vehicle_list_bloc.dart';
import 'Presentation/Bloc/Vehicle List Bloc/vehicle_list_event.dart';
import 'Presentation/Screens/add_vehicle_screen.dart';
import 'Presentation/Screens/profile_screen.dart';
import 'Presentation/Screens/vehicle_details_screen.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/vehicle_list_screen.dart';
import 'presentation/screens/login_screen.dart';


void main() {
  setupDi();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(getIt<LoginUseCase>()),
        ),
        BlocProvider(
          create: (context) => VehicleListBloc(getIt<GetVehiclesUseCase>())..add(FetchVehicles()),
        ),
        BlocProvider(
          create: (context) => VehicleDetailBloc(getIt<GetVehicleDetailsUseCase>(), getIt<StartRentalUseCase>()),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(getIt<GetProfileUseCase>(), getIt<LogoutUseCase>())..add(FetchProfile()),
        ),
        BlocProvider(
          create: (context) => AddVehicleBloc(getIt<AddVehicleUseCase>()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Vehicle Rental App',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/splash',
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}