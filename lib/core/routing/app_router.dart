import 'package:flutter/material.dart';
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
  const AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.root:
        return MaterialPageRoute<void>(builder: (_) => const SplashPage());
      case AppRoutes.login:
        return MaterialPageRoute<void>(builder: (_) => const LoginPage());
      case AppRoutes.register:
        return MaterialPageRoute<void>(builder: (_) => const RegisterPage());
      case AppRoutes.home:
        return MaterialPageRoute<void>(builder: (_) => const HomePage());
      default:
        return MaterialPageRoute<void>(builder: (_) => const SplashPage());
    }
  }
}
