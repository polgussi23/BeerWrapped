class RegisterResponse {
  final String accessToken;
  final String refreshToken;
  final int userId;
  final String username;

  RegisterResponse(
      {required this.accessToken,
      required this.refreshToken,
      required this.userId,
      required this.username});

  factory RegisterResponse.fromJson(Map<String, dynamic> json, String u) {
    return RegisterResponse(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      userId: json['userId'],
      username: u,
    );
  }
}
