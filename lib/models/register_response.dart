class RegisterResponse{
  final String token;
  final String userId;

  RegisterResponse({required this.token, required this.userId});

  factory RegisterResponse.fromJson(Map<String, dynamic> json){
    return RegisterResponse(
      token: json['token'],
      userId: json['message'],
    );
  }
}