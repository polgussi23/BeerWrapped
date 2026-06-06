class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final int userId;
  final String username;
  final String email;
  final String emailVerified;
  final String message;
  final String? startDay;
  final String? birthDate;

  LoginResponse(
      {required this.accessToken,
      required this.refreshToken,
      required this.userId,
      required this.username,
      required this.email,
      required this.emailVerified,
      required this.message,
      this.startDay,
      this.birthDate});

  factory LoginResponse.fromJson(Map<String, dynamic> json, String u) {
    return LoginResponse(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      message: json['message'],
      userId: json['userId'],
      email: json['email'],
      emailVerified: json['verified'],
      startDay: json['startDay'] ?? '',
      birthDate: json['birthdate'] ?? '',
      username: u,
    );
  }
}
