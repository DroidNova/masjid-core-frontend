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
    if (raw is JsonMap) {
      if (raw['data'] is JsonMap) {
        return AuthTokensModel.fromJson(raw['data'] as JsonMap);
      }
      return AuthTokensModel.fromJson(raw);
    }
    return const AuthTokensModel(accessToken: '', refreshToken: '');
  }

  JsonMap toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}
