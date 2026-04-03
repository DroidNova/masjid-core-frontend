import 'package:platform_core_frontend/features/auth/data/models/auth_tokens_model.dart';
import 'package:platform_core_frontend/features/auth/data/models/current_user_model.dart';
import 'package:platform_core_frontend/features/session/domain/entities/app_session.dart';
import 'package:platform_core_frontend/shared/types/json_types.dart';

class AppSessionModel extends AppSession {
  const AppSessionModel({
    super.user,
    super.tokens,
  });

  factory AppSessionModel.fromJson(JsonMap json) {
    return AppSessionModel(
      user: json['user'] is JsonMap
          ? CurrentUserModel.fromJson(json['user'] as JsonMap)
          : null,
      tokens: json['tokens'] is JsonMap
          ? AuthTokensModel.fromJson(json['tokens'] as JsonMap)
          : null,
    );
  }

  JsonMap toJson() {
    return {
      'user': user is CurrentUserModel
          ? (user as CurrentUserModel).toJson()
          : null,
      'tokens': tokens is AuthTokensModel
          ? (tokens as AuthTokensModel).toJson()
          : null,
    };
  }
}
