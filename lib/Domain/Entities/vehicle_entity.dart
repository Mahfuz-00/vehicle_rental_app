class Vehicle {
  final String id;
  final String name;
  final String type;
  final String status;
  final String image;
  final int battery;
  final Map<String, double> location;
  final double costPerMinute;

  Vehicle({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.image,
    required this.battery,
    required this.location,
    required this.costPerMinute,
  });
}