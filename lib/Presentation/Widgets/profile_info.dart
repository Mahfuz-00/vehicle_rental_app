import 'package:flutter/material.dart';
import '../../Domain/Entities/profile_entity.dart';

class ProfileInfo extends StatelessWidget {
  final Profile profile;

  const ProfileInfo({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Name: ${profile.name}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Email: ${profile.email}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Total Trips: ${profile.totalTrips}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}