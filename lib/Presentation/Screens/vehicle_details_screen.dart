import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Core/Widgets/error_widget.dart';
import '../../Core/Widgets/custom_button.dart';
import '../../Core/Navigation/app_router.dart';
import '../Bloc/Vehicle Details Bloc/vehicle_details_bloc.dart';
import '../Bloc/Vehicle Details Bloc/vehicle_details_event.dart';
import '../Bloc/Vehicle Details Bloc/vehicle_details_state.dart';

class VehicleDetailScreen extends StatelessWidget {
  const VehicleDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String? vehicleId = ModalRoute.of(context)!.settings.arguments as String?;
    if (vehicleId == null) {
      return const Scaffold(
        body: Center(child: Text('Vehicle ID required')),
      );
    }

    context.read<VehicleDetailBloc>().add(FetchVehicleDetails(vehicleId));

    return Scaffold(
      appBar: AppBar(title: const Text('Vehicle Details')),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<VehicleDetailBloc, VehicleDetailState>(
              listener: (context, state) {
                if (state is VehicleDetailRentalStarted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  Future.delayed(const Duration(seconds: 2), () {
                    Navigator.pop(context); // Return to VehicleListScreen
                  });
                }
              },
              builder: (context, state) {
                if (state is VehicleDetailLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is VehicleDetailLoaded) {
                  final vehicle = state.vehicle;
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CachedNetworkImage(
                            imageUrl: vehicle.image.isNotEmpty
                                ? vehicle.image
                                : 'https://firebasestorage.googleapis.com/v0/b/vehicle-rental-app-675fb.appspot.com/o/vehicles%2Fdefault.jpg?alt=media',
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Image.asset(
                              'Assets/Images/placeholder.png',
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Center(
                                child: Text('Image unavailable', style: TextStyle(color: Colors.red)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text('Name: ${vehicle.name}', style: const TextStyle(fontSize: 20)),
                          Text('Type: ${vehicle.type}'),
                          Text('Status: ${vehicle.status}'),
                          Text('Battery: ${vehicle.battery}%'),
                          Text('Location: (${vehicle.location['lat']}, ${vehicle.location['lng']})'),
                          Text('Cost: \$${vehicle.costPerMinute}/minute'),
                          const SizedBox(height: 16),
                          if (vehicle.status.toLowerCase() == 'available')
                            CustomButton(
                              text: 'Start Rental',
                              onPressed: () {
                                context.read<VehicleDetailBloc>().add(StartRental(vehicleId));
                              },
                            ),
                          if (vehicle.status.toLowerCase() != 'available')
                            const Text(
                              'This vehicle is currently unavailable for rental.',
                              style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic),
                            ),
                        ],
                      ),
                    ),
                  );
                } else if (state is VehicleDetailRentalStarted) {
                  return Center(child: Text(state.message));
                } else if (state is VehicleDetailError) {
                  return ErrorMessageWidget(
                    message: state.message,
                    onRetry: () {
                      context.read<VehicleDetailBloc>().add(FetchVehicleDetails(vehicleId));
                    },
                  );
                }
                return const Center(child: Text('No data available'));
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppRouter.buildBottomNavBar(context),
    );
  }
}