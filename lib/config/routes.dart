import 'package:flutter/material.dart';
import 'package:keep/ui/screens/screens.dart';

class Routes {
  static const String initial = '/';
  static const String login = '/login';
  static const String home = '/home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initial:
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: const SplashScreen(
            key: Key('Rouetes_SplashScreen'),
          ),
        );

      case login:
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: const LoginScreen(
            key: Key('Rouetes_LoginScreen'),
          ),
        );

      case home:
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: const HomeScreen(
            key: Key('Rouetes_HomeScreen'),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  static PageRoute _getPageRoute({String? routeName, required Widget viewToShow}) {
    return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (_) => viewToShow,
    );
  }
}
