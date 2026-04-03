import 'package:platform_core_frontend/features/admin/domain/entities/admin_user_summary.dart';

class AdminUsersState {
  const AdminUsersState({
    this.users = const <AdminUserSummary>[],
    this.isLoading = false,
    this.errorMessage,
    this.page = 1,
    this.limit = 20,
    this.total = 0,
  });

  final List<AdminUserSummary> users;
  final bool isLoading;
  final String? errorMessage;
  final int page;
  final int limit;
  final int total;

  AdminUsersState copyWith({
    List<AdminUserSummary>? users,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    int? page,
    int? limit,
    int? total,
  }) {
    return AdminUsersState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      page: page ?? this.page,
      limit: limit ?? this.limit,
      total: total ?? this.total,
    );
  }
}
