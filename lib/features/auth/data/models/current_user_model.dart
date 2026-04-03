import 'package:platform_core_frontend/core/network/response_mapper.dart';
import 'package:platform_core_frontend/features/auth/domain/entities/current_user.dart';
import 'package:platform_core_frontend/shared/types/json_types.dart';

class CurrentUserModel {
  const CurrentUserModel({
    required this.id,
    required this.email,
    required this.roles,
    required this.permissions,
    this.displayName,
  });

  final String id;
  final String email;
  final String? displayName;
  final List<String> roles;
  final List<String> permissions;

  factory CurrentUserModel.fromJson(JsonMap json) {
    final roles = (json['roles'] as List?)?.map((e) => e.toString()).toList() ??
        const <String>[];
    final permissions =
        (json['permissions'] as List?)?.map((e) => e.toString()).toList() ??
            const <String>[];

    return CurrentUserModel(
      id: (json['id'] ?? json['userId'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      displayName: (json['name'] ?? json['displayName'])?.toString(),
      roles: roles,
      permissions: permissions,
    );
  }

  factory CurrentUserModel.fromResponse(dynamic raw) {
    final json = ResponseMapper.unwrapDataMap(raw);
    return CurrentUserModel.fromJson(json);
  }

  CurrentUser toEntity() {
    return CurrentUser(
      id: id,
      email: email,
      displayName: displayName,
      roles: List<String>.from(roles),
      permissions: List<String>.from(permissions),
    );
  }

  JsonMap toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'roles': roles,
      'permissions': permissions,
    };
  }
}
