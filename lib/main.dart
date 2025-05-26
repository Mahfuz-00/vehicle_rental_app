import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Common/firebase_option.dart';
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
import 'package:firebase_core/firebase_core.dart';
import 'package:path/path.dart' as path;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Check if Firebase is already initialized
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    // Initialize App Check
    // await FirebaseAppCheck.instance.activate(
    //   androidProvider: AndroidProvider.playIntegrity, // Use Play Integrity
    // );
  };
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