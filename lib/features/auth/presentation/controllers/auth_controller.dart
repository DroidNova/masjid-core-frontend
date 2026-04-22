import 'package:flutter/foundation.dart';
import 'package:platform_core_frontend/core/auth/access_policy.dart';
import 'package:platform_core_frontend/core/errors/app_exception.dart';
import 'package:platform_core_frontend/core/network/api_result.dart';
import 'package:platform_core_frontend/core/storage/token_storage.dart';
import 'package:platform_core_frontend/features/auth/domain/entities/auth_tokens.dart';
import 'package:platform_core_frontend/features/auth/domain/entities/current_user.dart';
import 'package:platform_core_frontend/features/auth/domain/repositories/auth_repository.dart';
import 'package:platform_core_frontend/features/auth/presentation/state/auth_state.dart';

class AuthController extends ChangeNotifier {
  AuthController({
    required AuthRepository authRepository,
    required TokenStorage tokenStorage,
  })  : _authRepository = authRepository,
        _tokenStorage = tokenStorage;

  final AuthRepository _authRepository;
  final TokenStorage _tokenStorage;

  AuthState _state = const AuthState.initial();
  AuthState get state => _state;

  bool get canAccessAdmin => AccessPolicy.canViewAdmin(_state.user);

  bool get canViewSettings => AccessPolicy.canViewSettings(_state.user);

  bool get canManageUsers => AccessPolicy.canManageUsers(_state.user);

  Future<void> restoreSession() async {
    if (_state.status == AuthStatus.checking) {
      return;
    }

    _setState(
      _state.copyWith(
        status: AuthStatus.checking,
        clearError: true,
      ),
    );

    final accessToken = await _tokenStorage.getAccessToken();
    final refreshToken = await _tokenStorage.getRefreshToken();

    if (_isBlank(accessToken) && _isBlank(refreshToken)) {
      _markUnauthenticated();
      return;
    }

    final userResult = await _authRepository.getCurrentUser();
    if (await _applyCurrentUserResult(userResult)) {
      return;
    }

    if (_isBlank(refreshToken)) {
      await _tokenStorage.clearTokens();
      _markUnauthenticated();
      return;
    }

    final refreshResult =
        await _authRepository.refreshToken(refreshToken: refreshToken);
    switch (refreshResult) {
      case ApiSuccess<AuthTokens>():
        final retriedUserResult = await _authRepository.getCurrentUser();
        if (await _applyCurrentUserResult(retriedUserResult)) {
          return;
        }
      case ApiFailure<AuthTokens>():
        break;
    }

    await _tokenStorage.clearTokens();
    _markUnauthenticated(
      message: 'Your session has expired. Please sign in again.',
    );
  }

  Future<bool> login({
    required String emailOrPhone,
    required String password,
  }) async {
    return _submitAuth(
      action: () => _authRepository.login(
        payload: {
          'emailOrPhone': emailOrPhone.trim(),
          'password': password,
        },
      ),
    );
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _setState(
      _state.copyWith(
        isSubmitting: true,
        clearError: true,
      ),
    );

    final result = await _authRepository.register(
      payload: {
        'fullName': name.trim(),
        'email': email.trim(),
        'password': password,
      },
    );

    switch (result) {
      case ApiSuccess<AuthTokens>():
        await _tokenStorage.clearTokens();
        _setState(
          _state.copyWith(
            status: AuthStatus.unauthenticated,
            clearUser: true,
            clearError: true,
            isSubmitting: false,
            isLoggingOut: false,
          ),
        );
        return true;
      case ApiFailure<AuthTokens>(:final exception):
        _markUnauthenticated(message: _toUserMessage(exception));
        return false;
    }
  }

  Future<void> logout() async {
    _setState(
      _state.copyWith(
        isLoggingOut: true,
        clearError: true,
      ),
    );

    await _authRepository.logout();

    _setState(
      _state.copyWith(
        status: AuthStatus.unauthenticated,
        clearUser: true,
        clearError: true,
        isSubmitting: false,
        isLoggingOut: false,
      ),
    );
  }

  void clearError() {
    if (_state.errorMessage == null) {
      return;
    }

    _setState(_state.copyWith(clearError: true));
  }

  Future<bool> _submitAuth({
    required Future<ApiResult<AuthTokens>> Function() action,
  }) async {
    _setState(
      _state.copyWith(
        isSubmitting: true,
        clearError: true,
      ),
    );

    final authResult = await action();
    switch (authResult) {
      case ApiSuccess<AuthTokens>(:final data):
        final user = data.user;
        if (user != null) {
          _setState(
            _state.copyWith(
              status: AuthStatus.authenticated,
              user: user,
              clearError: true,
              isSubmitting: false,
              isLoggingOut: false,
            ),
          );
          return true;
        }
        final userResult = await _authRepository.getCurrentUser();
        final success = await _applyCurrentUserResult(userResult);
        if (!success) {
          _setState(_state.copyWith(isSubmitting: false));
        }
        return success;
      case ApiFailure<AuthTokens>(:final exception):
        _markUnauthenticated(message: _toUserMessage(exception));
        return false;
    }
  }

  Future<bool> _applyCurrentUserResult(ApiResult<CurrentUser> result) async {
    switch (result) {
      case ApiSuccess<CurrentUser>(:final data):
        _setState(
          _state.copyWith(
            status: AuthStatus.authenticated,
            user: data,
            clearError: true,
            isSubmitting: false,
            isLoggingOut: false,
          ),
        );
        return true;
      case ApiFailure<CurrentUser>(:final exception):
        _markUnauthenticated(message: _toUserMessage(exception));
        return false;
    }
  }

  void _markUnauthenticated({String? message}) {
    _setState(
      _state.copyWith(
        status: AuthStatus.unauthenticated,
        clearUser: true,
        errorMessage: message,
        clearError: message == null,
        isSubmitting: false,
        isLoggingOut: false,
      ),
    );
  }

  String _toUserMessage(AppException exception) {
    if (exception is UnauthorizedException) {
      final message = exception.message.toLowerCase();
      if (message.contains('invalid credential')) {
        return 'Invalid email or password.';
      }
      return 'Session expired. Please login again.';
    }
    if (exception is NetworkException) {
      return 'Network unavailable. Check your connection and try again.';
    }
    if (exception is ServerException) {
      return 'Server error. Please try again shortly.';
    }
    if (exception.message.trim().isNotEmpty) {
      return exception.message;
    }
    return 'Unable to complete request. Please try again.';
  }

  bool _isBlank(String? value) => value == null || value.isEmpty;

  void _setState(AuthState newState) {
    _state = newState;
    notifyListeners();
  }
}
