import 'package:platform_core_frontend/features/admin/domain/entities/admin_user_summary.dart';
import 'package:platform_core_frontend/shared/types/json_types.dart';

class AdminUserSummaryModel extends AdminUserSummary {
  const AdminUserSummaryModel({
    required super.id,
    required super.email,
    required super.status,
    required super.roles,
    super.name,
  });

  factory AdminUserSummaryModel.fromJson(JsonMap json) {
    final roles = (json['roles'] as List?)?.map((e) => e.toString()).toList() ??
        const <String>[];

    return AdminUserSummaryModel(
      id: (json['id'] ?? json['userId'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      name: (json['name'] ?? json['displayName'])?.toString(),
      status: (json['status'] ?? 'UNKNOWN').toString(),
      roles: roles,
    );
  }
}
