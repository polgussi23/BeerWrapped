class RegisterResponse {
  final String accessToken;
  final String refreshToken;
  final int userId;

  RegisterResponse(
      {required this.accessToken,
      required this.refreshToken,
      required this.userId});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      userId: json['userId'],
    );
  }
}
