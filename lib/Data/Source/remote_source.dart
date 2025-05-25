import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../Common/constant.dart';
import '../Model/profile_model.dart';
import '../Model/user_model.dart';
import '../Model/vehicle_model.dart';


class RemoteDataSource {
  final http.Client client;
  static const String baseUrl = 'https://mahfuz.com';

  RemoteDataSource(this.client);

  Future<UserModel> login(String email, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl/users'),
      body: jsonEncode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    print("Body : ${response.body}");
    if (response.statusCode == 201 || response.statusCode == 200) {
      return UserModel(
        token: 'abc123',
        id: 1,
        name: 'John Doe',
        email: email,
      );
    } else {
      throw Exception('Login failed');
    }
  }

  Future<List<VehicleModel>> getVehicles() async {
    final response = await client.get(
      Uri.parse('$baseUrl/vehicles'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return List.generate(
        30, // Limit to 30 vehicles
            (index) => VehicleModel(
          id: '${index + 1}',
          name: '${index + 1}',
          type: index % 2 == 0 ? '' : '',
          status: index % 3 == 0 ? '' : 'unavailable',
          image: 'https://picsum.photos/150', // Updated to reliable placeholder
          battery: 50 + (index % 50),
          location: {
            'lat': 40.7128 + (index * 0.01),
            'lng': -74.0060 + (index * 0.01),
          },
          costPerMinute: 0.20 + (index * 0.01),
        ),
      );
    } else {
      throw Exception('Failed to load vehicles');
    }
  }

  Future<VehicleModel> getVehicleDetails(String id) async {
    final response = await client.get(
      Uri.parse('$baseUrl/vehicles/$id'),
    );
    if (response.statusCode == 200) {
      return VehicleModel(
        id: id,
        name: 'Vehicle $id',
        type: int.parse(id) % 2 == 0 ? 'scooter' : 'bike',
        status: int.parse(id) % 3 == 0 ? 'available' : 'unavailable',
        image: 'https://picsum.photos/150', // Updated to reliable placeholder
        battery: 50 + (int.parse(id) % 50),
        location: {
          'lat': 40.7128 + (int.parse(id) * 0.01),
          'lng': -74.0060 + (int.parse(id) * 0.01),
        },
        costPerMinute: 0.20 + (int.parse(id) * 0.01),
      );
    } else {
      throw Exception('Failed to load vehicle details');
    }
  }

  Future<String> startRental(String id) async {
    final response = await client.post(
      Uri.parse('$baseUrl/rentals'),
      body: jsonEncode({'id': id}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return 'Rental started successfully';
    } else {
      throw Exception('Failed to start rental');
    }
  }

  Future<void> addVehicle(VehicleModel vehicle) async {
    final response = await client.post(
      Uri.parse('$baseUrl/vehicles'),
      body: jsonEncode(vehicle.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to add vehicle');
    }
  }

  Future<ProfileModel> getProfile() async {
    final response = await client.get(
      Uri.parse('$baseUrl/profile/1'),
    );
    if (response.statusCode == 200) {
      return ProfileModel(
        name: 'John Doe',
        email: 'user@example.com',
        totalTrips: 15,
      );
    } else {
      throw Exception('Failed to load profile');
    }
  }
}