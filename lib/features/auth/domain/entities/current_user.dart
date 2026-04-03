class CurrentUser {
  const CurrentUser({
    required this.id,
    required this.email,
    required this.roles,
    required this.permissions,
    this.displayName,
  });

  final String id;
  final String email;
  final String? displayName;
  final List<String> roles;
  final List<String> permissions;
}
