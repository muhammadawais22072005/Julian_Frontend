class UserRequest {
  final String email;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String password;
  final List<Map<String, dynamic>>? appointments;

  UserRequest({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.password,
    this.appointments,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'password': password,
      'appointments': appointments ?? [],
    };
  }
}