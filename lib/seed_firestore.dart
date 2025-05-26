import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

void main() async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyAs7z73ai_Ry-pgfaY-riMOJTnoxDd5qIk',
        appId: '1:113578205977:android:db7a072132ccfb318f9b88',
        messagingSenderId: '113578205977',
        projectId: 'vehicle-rental-app-675fb',
        storageBucket: 'vehicle-rental-app-675fb.firebasestorage.app',
      ),
    );
  }

  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  final random = Random();

  const vehicleBrands = [
    'Toyota', 'Honda', 'Ford', 'Chevrolet', 'BMW', 'Mercedes-Benz', 'Audi',
    'Tesla', 'Volkswagen', 'Hyundai', 'Nissan', 'Porsche', 'Ferrari', 'Subaru',
    'Harley-Davidson', 'Yamaha', 'Kawasaki', 'Ducati', 'Suzuki', 'Honda',
    'BMW Motorrad', 'Triumph', 'KTM', 'Indian Motorcycle',
    'Vespa', 'Piaggio', 'Yamaha', 'Honda', 'Sym', 'Kymco', 'Gogoro', 'Niu'
  ];

  const vehicleTypes = ['car', 'bike', 'scooter'];

  final imageDir = Directory('/Users/touchandsolve/Downloads/Cars');
  final imageFiles = imageDir
      .listSync()
      .where((file) => file is File && ['.jpg', '.jpeg', '.png'].contains(path.extension(file.path).toLowerCase()))
      .cast<File>()
      .toList();

  if (imageFiles.isEmpty) {
    print('Error: No images found in /Users/touchandsolve/Downloads/Cars');
    return;
  }

  for (var i = 1; i <= 30; i++) {
    final brand = vehicleBrands[random.nextInt(vehicleBrands.length)];
    final type = vehicleTypes[random.nextInt(vehicleTypes.length)];
    final imageFile = imageFiles[random.nextInt(imageFiles.length)];
    final imageName = 'vehicle$i${path.extension(imageFile.path)}';
    final storageRef = storage.ref('vehicles/$imageName');

    try {
      await storageRef.putFile(imageFile);
      final imageUrl = await storageRef.getDownloadURL();
      await firestore.collection('vehicles').doc('$i').set({
        'name': '$brand Model $i',
        'type': type,
        'status': i % 3 == 0 ? 'available' : 'unavailable',
        'image': imageUrl,
        'battery': 50 + (i % 50),
        'location': {
          'lat': 40.7128 + (i * 0.01),
          'lng': -74.0060 + (i * 0.01),
        },
        'costPerMinute': 0.20 + (i * 0.01),
      });
      print('Added vehicle $i: $brand Model $i');
    } catch (e) {
      print('Error uploading image or adding vehicle $i: $e');
    }
  }

  try {
    await firestore.collection('users').doc('test_uid').set({
      'name': 'Mahfuz',
      'email': 'mahfuz@vehicle.com',
      'totalTrips': 0,
    });
    print('Added test user');
  } catch (e) {
    print('Error adding test user: $e');
  }

  print('Data seeding completed');
}