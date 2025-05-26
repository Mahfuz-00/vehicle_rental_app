import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../Domain/Entities/vehicle_entity.dart';

class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleCard({Key? key, required this.vehicle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: const EdgeInsets.all(8),
      width: screenWidth * 0.45,
      height: screenHeight * 0.3,
      child: Card(
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/vehicle_detail', arguments: vehicle.id);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: CachedNetworkImage(
                  imageUrl: vehicle.image,
                  width: screenWidth * 0.4,
                  height: screenHeight * 0.15,
                  fit: BoxFit.fitWidth,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                vehicle.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                '${vehicle.type} - ${vehicle.status}',
                style: const TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
