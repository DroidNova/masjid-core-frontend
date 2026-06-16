import 'package:platform_core_frontend/features/auth/data/models/app_user.dart';

class CurrentUserRoleHelper {
  const CurrentUserRoleHelper._();

  static const String superAdmin = 'SUPER_ADMIN';
  static const String masjidAdmin = 'MASJID_ADMIN';
  static const String committeeMember = 'COMMITTEE_MEMBER';
  static const String imam = 'IMAM';
  static const String member = 'MEMBER';

  static bool hasRole(AppUser user, String role) {
    return user.roles.map((value) => value.toUpperCase()).contains(role);
  }

  static bool canAddUsers(AppUser user) {
    return allowedRolesToCreate(user).isNotEmpty;
  }

  static List<String> allowedRolesToCreate(AppUser user) {
    if (hasRole(user, superAdmin)) {
      return const <String>[imam, committeeMember];
    }
    if (hasRole(user, masjidAdmin)) {
      return const <String>[imam, committeeMember];
    }
    if (hasRole(user, committeeMember)) {
      return const <String>[member];
    }
    return const <String>[];
  }

  static String roleLabel(String role) {
    switch (role) {
      case member:
        return 'Member';
      case imam:
        return 'Imam';
      case committeeMember:
        return 'Committee Member';
      default:
        return role;
    }
  }
}
