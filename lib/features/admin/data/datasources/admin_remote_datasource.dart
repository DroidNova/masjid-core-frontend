import 'package:platform_core_frontend/core/constants/api_endpoints.dart';
import 'package:platform_core_frontend/core/network/api_result.dart';
import 'package:platform_core_frontend/core/network/dio_client.dart';
import 'package:platform_core_frontend/features/admin/data/models/admin_user_detail_model.dart';
import 'package:platform_core_frontend/features/admin/data/models/admin_users_page_result_model.dart';

class AdminRemoteDataSource {
  AdminRemoteDataSource(this._dioClient);

  final DioClient _dioClient;

  Future<ApiResult<AdminUsersPageResultModel>> getUsers({
    int page = 1,
    int limit = 20,
  }) {
    return _dioClient.get<AdminUsersPageResultModel>(
      ApiEndpoints.adminUsers,
      queryParameters: {
        'page': page,
        'limit': limit,
      },
      parser: AdminUsersPageResultModel.fromResponse,
    );
  }

  Future<ApiResult<AdminUserDetailModel>> getUserById(String id) {
    return _dioClient.get<AdminUserDetailModel>(
      ApiEndpoints.adminUserById(id),
      parser: AdminUserDetailModel.fromResponse,
    );
  }

  Future<ApiResult<AdminUserDetailModel>> updateUserStatus({
    required String id,
    required String status,
  }) {
    return _dioClient.patch<AdminUserDetailModel>(
      ApiEndpoints.adminUserStatus(id),
      data: {
        'status': status,
      },
      parser: AdminUserDetailModel.fromResponse,
    );
  }

  Future<ApiResult<AdminUserDetailModel>> assignUserRoles({
    required String id,
    required List<String> roles,
  }) {
    return _dioClient.post<AdminUserDetailModel>(
      ApiEndpoints.adminUserRoles(id),
      data: {
        'roles': roles,
      },
      parser: AdminUserDetailModel.fromResponse,
    );
  }
}
