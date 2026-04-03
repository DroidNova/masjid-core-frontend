import 'package:flutter/material.dart';
import 'package:platform_core_frontend/features/admin/domain/repositories/admin_repository.dart';
import 'package:platform_core_frontend/features/admin/presentation/pages/admin_user_detail_page.dart';
import 'package:platform_core_frontend/features/admin/presentation/pages/admin_users_page.dart';
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
  static const String adminUsers = '/admin/users';

  static String adminUserDetail(String id) => '/admin/users/$id';
}

class AppRouter {
  AppRouter({
    required AuthController authController,
    required AdminRepository adminRepository,
  })  : _authController = authController,
        _adminRepository = adminRepository;

  final AuthController _authController;
  final AdminRepository _adminRepository;

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final isAuthenticated = _authController.state.isAuthenticated;
    final routeName = settings.name ?? AppRoutes.root;

    if (_isProtectedRoute(routeName) && !isAuthenticated) {
      return MaterialPageRoute<void>(builder: (_) => const LoginPage());
    }

    if (_isPublicAuthRoute(routeName) && isAuthenticated) {
      return MaterialPageRoute<void>(builder: (_) => const HomePage());
    }

    if (_isAdminRoute(routeName) && !_authController.canAccessAdmin) {
      return MaterialPageRoute<void>(builder: (_) => const HomePage());
    }

    if (routeName.startsWith('${AppRoutes.adminUsers}/')) {
      final userId = routeName.replaceFirst('${AppRoutes.adminUsers}/', '');
      return MaterialPageRoute<void>(
        builder: (_) => AdminUserDetailPage(
          userId: userId,
          repository: _adminRepository,
        ),
      );
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
      case AppRoutes.adminUsers:
        return MaterialPageRoute<void>(
          builder: (_) => AdminUsersPage(repository: _adminRepository),
        );
      default:
        return MaterialPageRoute<void>(builder: (_) => const SplashPage());
    }
  }

  bool _isProtectedRoute(String routeName) {
    return routeName == AppRoutes.home ||
        routeName == AppRoutes.profile ||
        _isAdminRoute(routeName);
  }

  bool _isPublicAuthRoute(String routeName) {
    return routeName == AppRoutes.login || routeName == AppRoutes.register;
  }

  bool _isAdminRoute(String routeName) {
    return routeName == AppRoutes.adminUsers ||
        routeName.startsWith('${AppRoutes.adminUsers}/');
  }
}
