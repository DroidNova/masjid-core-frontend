import 'package:platform_core_frontend/features/auth/domain/entities/current_user.dart';
import 'package:platform_core_frontend/shared/types/json_types.dart';

class CurrentUserModel extends CurrentUser {
  const CurrentUserModel({
    required super.id,
    required super.email,
    required super.roles,
    required super.permissions,
    super.displayName,
  });

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
