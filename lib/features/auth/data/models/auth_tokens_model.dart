import 'package:platform_core_frontend/core/network/response_mapper.dart';
import 'package:platform_core_frontend/features/auth/domain/entities/auth_tokens.dart';
import 'package:platform_core_frontend/shared/types/json_types.dart';

class AuthTokensModel extends AuthTokens {
  const AuthTokensModel({
    required super.accessToken,
    required super.refreshToken,
  });

  factory AuthTokensModel.fromJson(JsonMap json) {
    final accessToken = json['accessToken'] ?? json['access_token'] ?? '';
    final refreshToken = json['refreshToken'] ?? json['refresh_token'] ?? '';

    return AuthTokensModel(
      accessToken: accessToken.toString(),
      refreshToken: refreshToken.toString(),
    );
  }

  factory AuthTokensModel.fromResponse(dynamic raw) {
    final json = ResponseMapper.unwrapDataMap(raw);
    return AuthTokensModel.fromJson(json);
  }

  JsonMap toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}
