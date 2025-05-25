abstract class AddVehicleEvent {}

class AddVehicleSubmitted extends AddVehicleEvent {
  final String id;
  final String name;
  final String type;
  final String status;
  final String image;
  final int battery;
  final double lat;
  final double lng;
  final double costPerMinute;

  AddVehicleSubmitted({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.image,
    required this.battery,
    required this.lat,
    required this.lng,
    required this.costPerMinute,
  });
}