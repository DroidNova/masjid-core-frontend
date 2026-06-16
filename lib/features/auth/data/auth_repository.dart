import 'package:platform_core_frontend/core/storage/session_storage.dart';
import 'package:platform_core_frontend/core/storage/token_storage.dart';
import 'package:platform_core_frontend/features/auth/data/auth_api.dart';
import 'package:platform_core_frontend/features/auth/data/models/auth_session.dart';
import 'package:platform_core_frontend/features/auth/data/models/login_start_response.dart';

class AuthRepository {
  AuthRepository({
    AuthApi? authApi,
    TokenStorage? tokenStorage,
    SessionStorage? sessionStorage,
  })  : _authApi = authApi ?? AuthApi(),
        _tokenStorage = tokenStorage ?? TokenStorage(),
        _sessionStorage = sessionStorage ?? SessionStorage();

  final AuthApi _authApi;
  final TokenStorage _tokenStorage;
  final SessionStorage _sessionStorage;

  Future<LoginStartResponse> startLogin(String phone) {
    return _authApi.startLogin(phone);
  }

  Future<LoginStartResponse> submitPassword(String phone, String password) {
    return _authApi.submitPassword(phone: phone, password: password);
  }

  Future<AuthSession> verifyOtp(
    String phone,
    String challengeId,
    String otp,
  ) async {
    final session = await _authApi.verifyOtp(
      phone: phone,
      challengeId: challengeId,
      otp: otp,
    );

    await _tokenStorage.saveTokens(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
    );
    await _sessionStorage.saveUser(session.user);

    return session;
  }

  Future<void> logout() async {
    await _tokenStorage.clearTokens();
    await _sessionStorage.clearUser();
  }
}
