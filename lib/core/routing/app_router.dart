import 'package:flutter/material.dart';
import 'package:platform_core_frontend/features/auth/presentation/controllers/auth_controller.dart';
import 'package:platform_core_frontend/features/auth/presentation/pages/login_page.dart';
import 'package:platform_core_frontend/features/auth/presentation/pages/register_page.dart';
import 'package:platform_core_frontend/features/auth/presentation/pages/splash_page.dart';
import 'package:platform_core_frontend/features/profile/presentation/pages/home_page.dart';
import 'package:platform_core_frontend/features/profile/presentation/pages/profile_page.dart';

class AppRoutes {
  const AppRoutes._();

  static const String root = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String profile = '/profile';
}

class AppRouter {
  AppRouter(this._authController);

  final AuthController _authController;

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final isAuthenticated = _authController.state.isAuthenticated;
    final routeName = settings.name ?? AppRoutes.root;

    if (_isProtectedRoute(routeName) && !isAuthenticated) {
      return MaterialPageRoute<void>(builder: (_) => const LoginPage());
    }

    if (_isPublicAuthRoute(routeName) && isAuthenticated) {
      return MaterialPageRoute<void>(builder: (_) => const HomePage());
    }

    switch (routeName) {
      case AppRoutes.root:
        return MaterialPageRoute<void>(builder: (_) => const SplashPage());
      case AppRoutes.login:
        return MaterialPageRoute<void>(builder: (_) => const LoginPage());
      case AppRoutes.register:
        return MaterialPageRoute<void>(builder: (_) => const RegisterPage());
      case AppRoutes.home:
        return MaterialPageRoute<void>(builder: (_) => const HomePage());
      case AppRoutes.profile:
        return MaterialPageRoute<void>(builder: (_) => const ProfilePage());
      default:
        return MaterialPageRoute<void>(builder: (_) => const SplashPage());
    }
  }

  bool _isProtectedRoute(String routeName) {
    return routeName == AppRoutes.home || routeName == AppRoutes.profile;
  }

  bool _isPublicAuthRoute(String routeName) {
    return routeName == AppRoutes.login || routeName == AppRoutes.register;
  }
}
