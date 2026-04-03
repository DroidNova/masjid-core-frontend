import 'package:platform_core_frontend/core/network/api_result.dart';
import 'package:platform_core_frontend/features/admin/data/datasources/admin_remote_datasource.dart';
import 'package:platform_core_frontend/features/admin/data/models/admin_user_detail_model.dart';
import 'package:platform_core_frontend/features/admin/data/models/admin_user_summary_model.dart';
import 'package:platform_core_frontend/features/admin/domain/entities/admin_user_detail.dart';
import 'package:platform_core_frontend/features/admin/domain/entities/admin_user_summary.dart';
import 'package:platform_core_frontend/features/admin/domain/repositories/admin_repository.dart';
import 'package:platform_core_frontend/shared/models/paginated_data.dart';
import 'package:platform_core_frontend/shared/types/list_query_params.dart';

class AdminRepositoryImpl implements AdminRepository {
  AdminRepositoryImpl(this._remoteDataSource);

  final AdminRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<PaginatedData<AdminUserSummary>>> getUsers({
    ListQueryParams query = const ListQueryParams(),
  }) async {
    final result = await _remoteDataSource.getUsers(query: query);
    return switch (result) {
      ApiSuccess<PaginatedData<AdminUserSummaryModel>>(:final data) =>
        ApiSuccess<PaginatedData<AdminUserSummary>>(
          PaginatedData<AdminUserSummary>(
            items: data.items
                .map(
                  (user) => AdminUserSummary(
                    id: user.id,
                    email: user.email,
                    status: user.status,
                    roles: List<String>.from(user.roles),
                    name: user.name,
                  ),
                )
                .toList(growable: false),
            meta: data.meta,
          ),
        ),
      ApiFailure<PaginatedData<AdminUserSummaryModel>>(:final exception) =>
        ApiFailure<PaginatedData<AdminUserSummary>>(exception),
    };
  }

  @override
  Future<ApiResult<AdminUserDetail>> getUserById(String id) async {
    final result = await _remoteDataSource.getUserById(id);
    return _mapUserDetailResult(result);
  }

  @override
  Future<ApiResult<AdminUserDetail>> updateUserStatus({
    required String id,
    required String status,
  }) async {
    final result = await _remoteDataSource.updateUserStatus(id: id, status: status);
    return _mapUserDetailResult(result);
  }

  @override
  Future<ApiResult<AdminUserDetail>> assignUserRoles({
    required String id,
    required List<String> roles,
  }) async {
    final result = await _remoteDataSource.assignUserRoles(id: id, roles: roles);
    return _mapUserDetailResult(result);
  }

  ApiResult<AdminUserDetail> _mapUserDetailResult(
    ApiResult<AdminUserDetailModel> result,
  ) {
    return switch (result) {
      ApiSuccess<AdminUserDetailModel>(:final data) => ApiSuccess<AdminUserDetail>(
          AdminUserDetail(
            id: data.id,
            email: data.email,
            status: data.status,
            roles: List<String>.from(data.roles),
            permissions: List<String>.from(data.permissions),
            name: data.name,
            createdAt: data.createdAt,
            updatedAt: data.updatedAt,
          ),
        ),
      ApiFailure<AdminUserDetailModel>(:final exception) =>
        ApiFailure<AdminUserDetail>(exception),
    };
  }
}
