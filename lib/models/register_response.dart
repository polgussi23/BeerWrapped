class RegisterResponse {
  final String accessToken;
  final String refreshToken;
  final int userId;
  final String username;
  final String email;
  final String birthDate;

  RegisterResponse(
      {required this.accessToken,
      required this.refreshToken,
      required this.userId,
      required this.username,
      required this.email,
      required this.birthDate});

  factory RegisterResponse.fromJson(Map<String, dynamic> json, String u) {
    return RegisterResponse(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      userId: json['userId'],
      birthDate: json['birthdate'],
      username: u,
      email: json['email'],
    );
  }
}
