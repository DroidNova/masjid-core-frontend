import 'package:platform_core_frontend/core/network/api_result.dart';
import 'package:platform_core_frontend/features/admin/domain/entities/admin_user_detail.dart';
import 'package:platform_core_frontend/features/admin/domain/entities/admin_users_page_result.dart';

abstract class AdminRepository {
  Future<ApiResult<AdminUsersPageResult>> getUsers({
    int page = 1,
    int limit = 20,
  });

  Future<ApiResult<AdminUserDetail>> getUserById(String id);

  Future<ApiResult<AdminUserDetail>> updateUserStatus({
    required String id,
    required String status,
  });

  Future<ApiResult<AdminUserDetail>> assignUserRoles({
    required String id,
    required List<String> roles,
  });
}
