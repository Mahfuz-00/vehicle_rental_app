import 'package:flutter/material.dart';
import '../../Presentation/Screens/add_vehicle_screen.dart';
import '../../Presentation/Screens/login_screen.dart';
import '../../Presentation/Screens/profile_screen.dart';
import '../../Presentation/Screens/splash_screen.dart';
import '../../Presentation/Screens/vehicle_details_screen.dart';
import '../../Presentation/Screens/vehicle_list_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/splash':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/dashboard':
        return MaterialPageRoute(builder: (_) => VehicleListScreen());
      case '/vehicle_detail':
        return MaterialPageRoute(
          builder: (_) => VehicleDetailScreen(),
          settings: settings,
        );
      case '/profile':
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      case '/add_vehicle':
        return MaterialPageRoute(builder: (_) => AddVehicleScreen());
      default:
        return MaterialPageRoute(builder: (_) => LoginScreen());
    }
  }

  static Widget buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      onTap: (index) {
        if (index == 0) {
          Navigator.pushNamed(context, '/dashboard');
        } else {
          Navigator.pushNamed(context, '/profile');
        }
      },
    );
  }

  static Widget buildTopBar(BuildContext context, String userName) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Hello, $userName',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              // Handle logout
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}