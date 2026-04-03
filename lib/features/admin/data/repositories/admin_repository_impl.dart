import 'package:platform_core_frontend/core/network/api_result.dart';
import 'package:platform_core_frontend/features/admin/data/datasources/admin_remote_datasource.dart';
import 'package:platform_core_frontend/features/admin/domain/entities/admin_user_detail.dart';
import 'package:platform_core_frontend/features/admin/domain/entities/admin_users_page_result.dart';
import 'package:platform_core_frontend/features/admin/domain/repositories/admin_repository.dart';

class AdminRepositoryImpl implements AdminRepository {
  AdminRepositoryImpl(this._remoteDataSource);

  final AdminRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<AdminUsersPageResult>> getUsers({
    int page = 1,
    int limit = 20,
  }) {
    return _remoteDataSource.getUsers(page: page, limit: limit);
  }

  @override
  Future<ApiResult<AdminUserDetail>> getUserById(String id) {
    return _remoteDataSource.getUserById(id);
  }

  @override
  Future<ApiResult<AdminUserDetail>> updateUserStatus({
    required String id,
    required String status,
  }) {
    return _remoteDataSource.updateUserStatus(id: id, status: status);
  }

  @override
  Future<ApiResult<AdminUserDetail>> assignUserRoles({
    required String id,
    required List<String> roles,
  }) {
    return _remoteDataSource.assignUserRoles(id: id, roles: roles);
  }
}
