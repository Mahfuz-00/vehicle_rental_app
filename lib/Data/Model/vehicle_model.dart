import '../../Domain/Entities/vehicle_entity.dart';

class VehicleModel {
  final String id;
  final String name;
  final String type;
  final String status;
  final String image;
  final int battery;
  final Map<String, double> location;
  final double costPerMinute;

  VehicleModel({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.image,
    required this.battery,
    required this.location,
    required this.costPerMinute,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
      image: json['image'] as String,
      battery: json['battery'] as int,
      location: {
        'lat': (json['location']['lat'] as num).toDouble(),
        'lng': (json['location']['lng'] as num).toDouble(),
      },
      costPerMinute: (json['cost_per_minute'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'status': status,
      'image': image,
      'battery': battery,
      'location': location,
      'cost_per_minute': costPerMinute,
    };
  }

  Vehicle toEntity() {
    return Vehicle(
      id: id,
      name: name,
      type: type,
      status: status,
      image: image,
      battery: battery,
      location: location,
      costPerMinute: costPerMinute,
    );
  }

  factory VehicleModel.fromEntity(Vehicle vehicle) {
    return VehicleModel(
      id: vehicle.id,
      name: vehicle.name,
      type: vehicle.type,
      status: vehicle.status,
      image: vehicle.image,
      battery: vehicle.battery,
      location: vehicle.location,
      costPerMinute: vehicle.costPerMinute,
    );
  }
}