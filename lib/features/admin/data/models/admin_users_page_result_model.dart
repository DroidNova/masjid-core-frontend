import 'package:platform_core_frontend/features/admin/data/models/admin_user_summary_model.dart';
import 'package:platform_core_frontend/features/admin/domain/entities/admin_users_page_result.dart';
import 'package:platform_core_frontend/shared/types/json_types.dart';

class AdminUsersPageResultModel extends AdminUsersPageResult {
  const AdminUsersPageResultModel({
    required super.users,
    required super.page,
    required super.limit,
    required super.total,
  });

  factory AdminUsersPageResultModel.fromResponse(dynamic raw) {
    JsonMap payload = const {};
    if (raw is JsonMap) {
      if (raw['data'] is JsonMap) {
        payload = raw['data'] as JsonMap;
      } else {
        payload = raw;
      }
    }

    final itemsRaw = payload['items'] ?? payload['users'] ?? payload['data'] ?? const [];
    final items = (itemsRaw as List?)
            ?.whereType<JsonMap>()
            .map(AdminUserSummaryModel.fromJson)
            .toList() ??
        const <AdminUserSummaryModel>[];

    return AdminUsersPageResultModel(
      users: items,
      page: _toInt(payload['page'], fallback: 1),
      limit: _toInt(payload['limit'], fallback: items.isEmpty ? 20 : items.length),
      total: _toInt(payload['total'], fallback: items.length),
    );
  }

  static int _toInt(dynamic raw, {required int fallback}) {
    if (raw is int) return raw;
    return int.tryParse(raw?.toString() ?? '') ?? fallback;
  }
}
