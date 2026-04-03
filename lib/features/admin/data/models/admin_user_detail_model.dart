import 'package:platform_core_frontend/core/network/response_mapper.dart';
import 'package:platform_core_frontend/features/admin/domain/entities/admin_user_detail.dart';
import 'package:platform_core_frontend/shared/types/json_types.dart';

class AdminUserDetailModel extends AdminUserDetail {
  const AdminUserDetailModel({
    required super.id,
    required super.email,
    required super.status,
    required super.roles,
    required super.permissions,
    super.name,
    super.createdAt,
    super.updatedAt,
  });

  factory AdminUserDetailModel.fromJson(JsonMap json) {
    final roles = (json['roles'] as List?)?.map((e) => e.toString()).toList() ??
        const <String>[];
    final permissions =
        (json['permissions'] as List?)?.map((e) => e.toString()).toList() ??
            const <String>[];

    return AdminUserDetailModel(
      id: (json['id'] ?? json['userId'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      name: (json['name'] ?? json['displayName'])?.toString(),
      status: (json['status'] ?? 'UNKNOWN').toString(),
      roles: roles,
      permissions: permissions,
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  factory AdminUserDetailModel.fromResponse(dynamic raw) {
    final json = ResponseMapper.unwrapDataMap(raw);
    return AdminUserDetailModel.fromJson(json);
  }
}
