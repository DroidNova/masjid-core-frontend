import 'package:platform_core_frontend/features/auth/domain/entities/current_user.dart';

class AccessPolicy {
  const AccessPolicy._();

  static bool hasRole(CurrentUser? user, String role) {
    final normalized = role.toUpperCase();
    return user?.roles.any((entry) => entry.toUpperCase() == normalized) ?? false;
  }

  static bool hasPermission(CurrentUser? user, String permission) {
    final normalized = permission.toLowerCase();
    return user?.permissions
            .any((entry) => entry.toLowerCase() == normalized) ??
        false;
  }

  static bool canViewAdmin(CurrentUser? user) {
    return hasRole(user, 'SUPER_ADMIN') ||
        hasRole(user, 'ADMIN') ||
        user?.permissions.any((entry) => entry.toLowerCase().contains('admin')) == true;
  }

  static bool canManageUsers(CurrentUser? user) {
    return hasPermission(user, 'users:write') || canViewAdmin(user);
  }

  static bool canViewSettings(CurrentUser? user) {
    return hasPermission(user, 'settings:read') || canViewAdmin(user);
  }
}
