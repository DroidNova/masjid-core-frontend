import 'package:platform_core_frontend/core/network/response_mapper.dart';
import 'package:platform_core_frontend/features/auth/domain/entities/auth_tokens.dart';
import 'package:platform_core_frontend/shared/types/json_types.dart';

class AuthTokensModel {
  const AuthTokensModel({
    required this.accessToken,
    required this.refreshToken,
  });

  final String accessToken;
  final String refreshToken;

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
    final tokenMap = (json['tokens'] is Map<String, dynamic>)
        ? json['tokens'] as Map<String, dynamic>
        : json;
    return AuthTokensModel.fromJson(tokenMap);
  }

  AuthTokens toEntity() {
    return AuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  JsonMap toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}
