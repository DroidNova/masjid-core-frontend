import 'package:platform_core_frontend/features/admin/domain/entities/admin_user_summary.dart';

class AdminUsersPageResult {
  const AdminUsersPageResult({
    required this.users,
    required this.page,
    required this.limit,
    required this.total,
  });

  final List<AdminUserSummary> users;
  final int page;
  final int limit;
  final int total;
}
