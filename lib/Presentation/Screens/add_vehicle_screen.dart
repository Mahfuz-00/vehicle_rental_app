import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Core/Navigation/app_router.dart';
import '../../Core/Widgets/custom_button.dart';
import '../../Core/Widgets/custom_text_field.dart';
import '../Bloc/Add Vehicle Bloc/add_vehicle_bloc.dart';
import '../Bloc/Add Vehicle Bloc/add_vehicle_event.dart';
import '../Bloc/Add Vehicle Bloc/add_vehicle_state.dart';


class AddVehicleScreen extends StatefulWidget {
  @override
  _AddVehicleScreenState createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _statusController = TextEditingController();
  final _imageController = TextEditingController();
  final _batteryController = TextEditingController();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();
  final _costController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Vehicle')),
      body: Column(
        children: [
          // AppRouter.buildTopBar(context, 'John Doe'), // Replace with dynamic user name
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomTextField(controller: _idController, label: 'ID'),
                    CustomTextField(controller: _nameController, label: 'Name'),
                    CustomTextField(controller: _typeController, label: 'Type'),
                    CustomTextField(controller: _statusController, label: 'Status'),
                    CustomTextField(controller: _imageController, label: 'Image URL'),
                    CustomTextField(controller: _batteryController, label: 'Battery (%)', keyboardType: TextInputType.number),
                    CustomTextField(controller: _latController, label: 'Latitude', keyboardType: TextInputType.number),
                    CustomTextField(controller: _lngController, label: 'Longitude', keyboardType: TextInputType.number),
                    CustomTextField(controller: _costController, label: 'Cost per Minute', keyboardType: TextInputType.number),
                    const SizedBox(height: 16),
                    BlocConsumer<AddVehicleBloc, AddVehicleState>(
                      listener: (context, state) {
                        if (state is AddVehicleSuccess) {
                          Navigator.pop(context);
                        } else if (state is AddVehicleError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        }
                      },
                      builder: (context, state) {
                        return CustomButton(
                          text: 'Add Vehicle',
                          isLoading: state is AddVehicleLoading,
                          onPressed: () {
                            context.read<AddVehicleBloc>().add(
                              AddVehicleSubmitted(
                                id: _idController.text,
                                name: _nameController.text,
                                type: _typeController.text,
                                status: _statusController.text,
                                image: _imageController.text,
                                battery: int.parse(_batteryController.text),
                                lat: double.parse(_latController.text),
                                lng: double.parse(_lngController.text),
                                costPerMinute: double.parse(_costController.text),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppRouter.buildBottomNavBar(context),
    );
  }
}