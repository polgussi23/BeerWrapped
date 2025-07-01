class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final int userId;
  final String message;
  final String? startDay;

  LoginResponse(
      {required this.accessToken,
      required this.refreshToken,
      required this.userId,
      required this.message,
      this.startDay});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      message: json['message'],
      userId: json['userId'],
      startDay: json['startDay'] ?? '',
    );
  }
}
