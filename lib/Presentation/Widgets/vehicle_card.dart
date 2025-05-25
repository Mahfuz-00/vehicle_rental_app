import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../Domain/Entities/vehicle_entity.dart';

class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleCard({Key? key, required this.vehicle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CachedNetworkImage(
          imageUrl: vehicle.image,
          width: 50,
          height: 50,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        title: Text(vehicle.name),
        subtitle: Text('${vehicle.type} - ${vehicle.status}'),
        onTap: () {
          Navigator.pushNamed(context, '/vehicle_detail', arguments: vehicle.id);
        },
      ),
    );
  }
}