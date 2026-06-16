import 'package:platform_core_frontend/features/auth/data/models/app_user.dart';

class AuthSession {
  const AuthSession({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'];

    if (userJson is! Map<String, dynamic>) {
      throw const FormatException('User information is missing from response.');
    }

    return AuthSession(
      user: AppUser.fromJson(userJson),
      accessToken: json['accessToken']?.toString() ?? '',
      refreshToken: json['refreshToken']?.toString() ?? '',
    );
  }

  final AppUser user;
  final String accessToken;
  final String refreshToken;
}
