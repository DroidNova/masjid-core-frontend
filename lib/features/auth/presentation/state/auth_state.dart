import 'package:platform_core_frontend/features/auth/domain/entities/current_user.dart';

enum AuthStatus {
  initial,
  checking,
  authenticated,
  unauthenticated,
}

class AuthState {
  const AuthState({
    required this.status,
    this.user,
    this.errorMessage,
    this.isSubmitting = false,
    this.isLoggingOut = false,
  });

  const AuthState.initial()
      : status = AuthStatus.initial,
        user = null,
        errorMessage = null,
        isSubmitting = false,
        isLoggingOut = false;

  final AuthStatus status;
  final CurrentUser? user;
  final String? errorMessage;
  final bool isSubmitting;
  final bool isLoggingOut;

  bool get isAuthenticated => status == AuthStatus.authenticated;

  AuthState copyWith({
    AuthStatus? status,
    CurrentUser? user,
    bool clearUser = false,
    String? errorMessage,
    bool clearError = false,
    bool? isSubmitting,
    bool? isLoggingOut,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
    );
  }
}
