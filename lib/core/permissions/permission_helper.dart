import 'package:platform_core_frontend/features/auth/data/models/app_user.dart';

class PermissionHelper {
  const PermissionHelper._();
  static bool hasRole(AppUser? user, String role) => user?.roles.map((r)=>r.toUpperCase()).contains(role.toUpperCase()) ?? false;
  static bool isSuperAdmin(AppUser? user) => hasRole(user, 'SUPER_ADMIN');
}
