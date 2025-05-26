import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Common/constant.dart';
import '../Model/profile_model.dart';
import '../Model/user_model.dart';
import '../Model/vehicle_model.dart';

class RemoteDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      print('user name: $user');
      if (user == null) {
        throw Exception('Login failed: User not found');
      }
      final token = await user.getIdToken();
      print('Token : $token');
      if (token == null) {
        throw Exception('Login failed: Unable to retrieve token');
      }
      final doc = await _firestore.collection('users').doc(user.uid).get();
      print('Users: ${doc.id}, ${doc.data()}');
      return UserModel(
        token: token,
        id: user.uid,
        name: doc.data()?['name'] ?? 'John Doe',
        email: email,
      );
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth error: ${e.code} - ${e.message}');
      throw Exception('Login failed: ${e.message}');
    } catch (e) {
      print('Login failed: $e');
      throw Exception('Login failed: $e');
    }
  }

  Future<List<VehicleModel>> getVehicles() async {
    try {
      final snapshot = await _firestore.collection('vehicles').get(); // Removed limit(30)
      final vehicles = <VehicleModel>[];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        print('Vehicle List: $data');

        // Check and fix Google Drive image URL
        String imageUrl = data['image'] as String? ?? '';
        if (imageUrl.contains('drive.google.com/file/d/')) {
          final fileId = imageUrl.split('/d/')[1].split('/')[0];
          final directUrl = 'https://drive.google.com/uc?id=$fileId';
          await doc.reference.update({'image': directUrl});
          print('Updated vehicle ${doc.id} image to: $directUrl');
          imageUrl = directUrl; // Use the updated URL for VehicleModel
        }

        vehicles.add(VehicleModel(
          id: doc.id,
          name: data['name'] ?? 'Vehicle ${doc.id}',
          type: data['type'] ?? 'vehicle',
          status: data['status'] ?? 'unavailable',
          image: imageUrl,
          battery: (data['battery'] as num?)?.toInt() ?? 0,
          location: {
            'lat': (data['location']?['lat'] as num?)?.toDouble() ?? 0,
            'lng': (data['location']?['lng'] as num?)?.toDouble() ?? 0,
          },
          costPerMinute: (data['costPerMinute'] as num?)?.toDouble() ?? 0,
        ));
      }

      return vehicles;
    } catch (e) {
      print('Failed to load vehicles: $e');
      throw Exception('Error loading vehicles: $e');
    }
  }

  Future<VehicleModel> getVehicleDetails(String id) async {
    try {
      final doc = await _firestore.collection('vehicles').doc(id).get();
      if (doc.exists) {
        final data = doc.data()!;
        return VehicleModel(
          id: doc.id,
          name: data['name'] ?? 'Vehicle $id',
          type: data['type'] ?? 'scooter',
          status: data['status'] ?? 'available',
          image: data['image'] ?? '',
          battery: (data['battery'] as num?)?.toInt() ?? 50,
          location: {
            'lat': (data['location']?['lat'] as num?)?.toDouble() ?? 40.7128,
            'lng': (data['location']?['lng'] as num?)?.toDouble() ?? -74.0060,
          },
          costPerMinute: (data['costPerMinute'] as num?)?.toDouble() ?? 0.20,
        );
      }
      throw Exception('Vehicle not found');
    } catch (e) {
      throw Exception('Failed to load vehicle details: $e');
    }
  }

  Future<String> startRental(String id) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');
      await _firestore.collection('rentals').add({
        'vehicleId': id,
        'userId': user.uid,
        'startTime': FieldValue.serverTimestamp(),
      });
      await _firestore.collection('vehicles').doc(id).update({'status': 'Unavailable'});

      // Increment user's totalTrips
      final userDocRef = _firestore.collection('users').doc(user.uid);
      await _firestore.runTransaction((transaction) async {
        final userDoc = await transaction.get(userDocRef);
        if (userDoc.exists) {
          final currentTrips = (userDoc.data()?['totalTrips'] as num?)?.toInt() ?? 0;
          transaction.update(userDocRef, {'totalTrips': currentTrips + 1});
        } else {
          throw Exception('User not found');
        }
      });


      return 'Rental started successfully';
    } catch (e) {
      throw Exception('Failed to start rental: $e');
    }
  }

  Future<void> addVehicle(VehicleModel vehicle) async {
    try {
      await _firestore.collection('vehicles').add(vehicle.toJson());
    } catch (e) {
      throw Exception('Failed to add vehicle: $e');
    }
  }

  Future<ProfileModel> getProfile() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        return ProfileModel(
          name: data['name'] ?? '',
          email: data['email'] ?? '',
          totalTrips: (data['totalTrips'] as num?)?.toInt() ?? 0,
        );
      }
      throw Exception('Profile not found');
    } catch (e) {
      throw Exception('Failed to load profile: $e');
    }
  }
}