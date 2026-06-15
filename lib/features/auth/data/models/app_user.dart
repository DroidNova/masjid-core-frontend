class AppUser {
  const AppUser({
    required this.id,
    required this.fullName,
    required this.roles,
    this.email,
    this.phone,
    this.status,
    this.masjidId,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      status: json['status']?.toString(),
      masjidId: json['masjidId']?.toString(),
      roles: (json['roles'] as List<dynamic>? ?? const <dynamic>[])
          .map((role) => role.toString())
          .toList(),
    );
  }

  final String id;
  final String fullName;
  final String? email;
  final String? phone;
  final String? status;
  final String? masjidId;
  final List<String> roles;
}
