import 'package:flutter/material.dart';

import '../screens/auth_screen.dart';
import '../screens/home_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/model_config_screen.dart';

/// Defines app routes and provides access to route names
class Routes {
  Routes._(); // Private constructor to prevent instantiation

  // Route names
  static const String splash = '/splash';
  static const String home = '/home';
  static const String auth = '/auth';
  static const String settings = '/settings';
  static const String modelConfig = '/model-config';

  /// Returns map of named routes and their builder functions
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      home: (context) => const HomeScreen(),
      auth: (context) => const AuthScreen(),
      settings: (context) => const SettingsScreen(),
      modelConfig: (context) => const ModelConfigScreen(),
    };
  }
}