class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String role; // 'admin' or 'patient'
  final String? token;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      role: json['role'] as String,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'role': role,
      'token': token,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? role,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      token: token ?? this.token,
    );
  }
}
