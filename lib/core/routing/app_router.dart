import 'package:flutter/material.dart';
import 'package:platform_core_frontend/features/auth/presentation/controllers/auth_controller.dart';
import 'package:platform_core_frontend/features/auth/presentation/pages/login_page.dart';
import 'package:platform_core_frontend/features/auth/presentation/pages/register_page.dart';
import 'package:platform_core_frontend/features/auth/presentation/pages/splash_page.dart';
import 'package:platform_core_frontend/features/profile/presentation/pages/home_page.dart';

class AppRoutes {
  const AppRoutes._();

  static const String root = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
}

class AppRouter {
  AppRouter(this._authController);

  final AuthController _authController;

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final isAuthenticated = _authController.state.isAuthenticated;

    switch (settings.name) {
      case AppRoutes.root:
        return MaterialPageRoute<void>(builder: (_) => const SplashPage());
      case AppRoutes.login:
        if (isAuthenticated) {
          return MaterialPageRoute<void>(builder: (_) => const HomePage());
        }
        return MaterialPageRoute<void>(builder: (_) => const LoginPage());
      case AppRoutes.register:
        if (isAuthenticated) {
          return MaterialPageRoute<void>(builder: (_) => const HomePage());
        }
        return MaterialPageRoute<void>(builder: (_) => const RegisterPage());
      case AppRoutes.home:
        if (!isAuthenticated) {
          return MaterialPageRoute<void>(builder: (_) => const LoginPage());
        }
        return MaterialPageRoute<void>(builder: (_) => const HomePage());
      default:
        return MaterialPageRoute<void>(builder: (_) => const SplashPage());
    }
  }
}
