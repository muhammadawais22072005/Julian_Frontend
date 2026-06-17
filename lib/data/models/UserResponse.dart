class UserResponse {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt; // Marked nullable as it might be null initially
  final String phoneNumber;

  UserResponse({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
    required this.phoneNumber,
  });

  // This factory turns the raw JSON map from the server into a typed UserResponse object
  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'] as int,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      role: json['role'] as String,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      phoneNumber: json['phoneNumber'] as String,
    );
  }
}