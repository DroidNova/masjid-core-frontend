import 'package:flutter/foundation.dart';
import 'package:platform_core_frontend/core/errors/app_exception.dart';
import 'package:platform_core_frontend/core/network/api_result.dart';
import 'package:platform_core_frontend/core/storage/token_storage.dart';
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
    if (accessToken == null || accessToken.isEmpty) {
      _setState(
        _state.copyWith(
          status: AuthStatus.unauthenticated,
          clearUser: true,
          clearError: true,
        ),
      );
      return;
    }

    final result = await _authRepository.getCurrentUser();
    await _handleCurrentUserResult(result, clearTokensOnFailure: true);
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setSubmitting(true);

    final result = await _authRepository.login(
      payload: {
        'email': email.trim(),
        'password': password,
      },
    );

    return _handleAuthResult(result);
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _setSubmitting(true);

    final result = await _authRepository.register(
      payload: {
        'name': name.trim(),
        'email': email.trim(),
        'password': password,
      },
    );

    return _handleAuthResult(result);
  }

  Future<void> logout() async {
    _setSubmitting(true);
    await _authRepository.logout();
    _setState(
      _state.copyWith(
        status: AuthStatus.unauthenticated,
        clearUser: true,
        clearError: true,
        isSubmitting: false,
      ),
    );
  }

  void clearError() {
    if (_state.errorMessage == null) {
      return;
    }

    _setState(_state.copyWith(clearError: true));
  }

  Future<bool> _handleAuthResult(ApiResult<dynamic> result) async {
    switch (result) {
      case ApiSuccess<dynamic>():
        final userResult = await _authRepository.getCurrentUser();
        return _handleCurrentUserResult(userResult);
      case ApiFailure<dynamic>(:final exception):
        _setState(
          _state.copyWith(
            status: AuthStatus.unauthenticated,
            clearUser: true,
            errorMessage: _toUserMessage(exception),
            isSubmitting: false,
          ),
        );
        return false;
    }
  }

  Future<bool> _handleCurrentUserResult(
    ApiResult<CurrentUser> result, {
    bool clearTokensOnFailure = false,
  }) async {
    switch (result) {
      case ApiSuccess<CurrentUser>(:final data):
        _setState(
          _state.copyWith(
            status: AuthStatus.authenticated,
            user: data,
            clearError: true,
            isSubmitting: false,
          ),
        );
        return true;
      case ApiFailure<CurrentUser>(:final exception):
        if (clearTokensOnFailure) {
          await _tokenStorage.clearTokens();
        }
        _setState(
          _state.copyWith(
            status: AuthStatus.unauthenticated,
            clearUser: true,
            errorMessage: _toUserMessage(exception),
            isSubmitting: false,
          ),
        );
        return false;
    }
  }

  String _toUserMessage(AppException exception) {
    if (exception is UnauthorizedException) {
      return 'Session expired. Please login again.';
    }
    if (exception is NetworkException) {
      return 'Network unavailable. Check your connection and try again.';
    }
    if (exception is ServerException) {
      return 'Server error. Please try again shortly.';
    }
    return 'Unable to complete request. Please try again.';
  }

  void _setSubmitting(bool value) {
    _setState(
      _state.copyWith(
        isSubmitting: value,
        clearError: true,
      ),
    );
  }

  void _setState(AuthState newState) {
    _state = newState;
    notifyListeners();
  }
}
