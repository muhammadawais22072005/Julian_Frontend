class ChangePassword {
  final String password;
  final String repeatPassword;

  ChangePassword({required this.password, required this.repeatPassword});

  Map<String, dynamic> toJson() {
    return {
      'password': password,
      'repeatPassword': repeatPassword,
    };
  }
}