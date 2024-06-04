import 'package:flutter/material.dart';
import '../screens/login_screen.dart'; // Import the login screen
import '../screens/home_screen.dart'; // Import the home screen
import '../screens/detail_screen.dart'; // Import the detail screen
import '../screens/cart_screen.dart'; // Import the detail screen

class AppRoutes {
  static const String login = '/';
  static const String home = '/home';
  static const String detail = '/detail';
  static const String cart = '/cart';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case cart:
        return MaterialPageRoute(builder: (_) => const CartScreen());
      case detail:
        final item = settings.arguments as Map<String, String>;
        return MaterialPageRoute(builder: (_) => DetailScreen(item: item));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
