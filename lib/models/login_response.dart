class LoginResponse{
  final String token;
  final int userId;
  final String message;
  final String? startDay;

  LoginResponse({required this.token, required this.userId, required this.message, this.startDay});

  factory LoginResponse.fromJson(Map<String, dynamic> json){
    return LoginResponse(
      token: json['token'],
      message: json['message'],
      userId: json['userId'],
      startDay: json['startDay'] ?? '',
    );
  }
}