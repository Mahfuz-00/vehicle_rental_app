import 'package:flutter/material.dart';

import '../../Core/Dependency Injection/dependency_injection.dart';
import '../../Data/Source/local_source.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate loading
    final localDataSource = getIt<LocalDataSource>();
    final token = await localDataSource.getToken();
    final rememberMe = await localDataSource.getRememberMe();

    if (token != null && rememberMe) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Draggable(
          child: Image.asset(
            'Assets/Images/logo.png',
            height: 100,
            errorBuilder: (context, error, stackTrace) => const Text(
              'Vehicle Rental App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          feedback: Image.asset(
            'Assets/Images/logo.png',
            height: 100,
            opacity: const AlwaysStoppedAnimation(0.5),
            errorBuilder: (context, error, stackTrace) => const Text(
              'Vehicle Rental App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          childWhenDragging: const SizedBox(),
        ),
      ),
    );
  }
}