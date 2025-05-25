import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Core/Navigation/app_router.dart';
import '../../Core/Widgets/custom_button.dart';
import '../Bloc/Profile Bloc/profile_bloc.dart';
import '../Bloc/Profile Bloc/profile_event.dart';
import '../Bloc/Profile Bloc/profile_state.dart';


class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Column(
        children: [
          AppRouter.buildTopBar(context, 'John Doe'), // Replace with dynamic user name
          Expanded(
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProfileLoaded) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name: ${state.profile.name}', style: const TextStyle(fontSize: 20)),
                        Text('Email: ${state.profile.email}'),
                        Text('Total Trips: ${state.profile.totalTrips}'),
                        const SizedBox(height: 16),
                        CustomButton(
                          text: 'Logout',
                          onPressed: () {
                            context.read<ProfileBloc>().add(Logout());
                          },
                        ),
                      ],
                    ),
                  );
                } else if (state is ProfileError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppRouter.buildBottomNavBar(context),
    );
  }
}