import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../Bloc/Vehicle List Bloc/vehicle_list_bloc.dart';
import '../Bloc/Vehicle List Bloc/vehicle_list_event.dart';
import '../Bloc/Vehicle List Bloc/vehicle_list_state.dart';
import '../widgets/vehicle_card.dart';

class VehicleListScreen extends StatelessWidget {
  final RefreshController _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Handle logout
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: () {
          context.read<VehicleListBloc>().add(FetchVehicles());
          _refreshController.refreshCompleted();
        },
        child: BlocBuilder<VehicleListBloc, VehicleListState>(
          builder: (context, state) {
            if (state is VehicleListLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is VehicleListLoaded) {
              return GridView.builder(
                padding: const EdgeInsets.all(2),
                itemCount: state.vehicles.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,              // 2 items per row
                  crossAxisSpacing: 1,           // space between columns
                  mainAxisSpacing: 1,            // space between rows
                  childAspectRatio: 0.95,         // adjust height/width ratio of each card
                ),
                itemBuilder: (context, index) {
                  return VehicleCard(vehicle: state.vehicles[index]);
                },
              );
            } else if (state is VehicleListError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('No vehicles available'));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add_vehicle'),
        child: const Icon(Icons.add),
      ),
    );
  }
}