import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import '../models/login_response.dart';

class LoginService{
  Future<LoginResponse> loginUser(String username, String password) async{
    
    final String apiUrlBase = dotenv.env['API_URL'] ?? 'http://217.160.2.122:3100';
    
    final Uri apiUrlLogin = Uri.parse('$apiUrlBase/api/auth/login');
    
    try{
      final response = await http.post(
        apiUrlLogin,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200){
        return LoginResponse.fromJson(jsonDecode(response.body));
      }else{
        throw Exception('Error en el login: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de connexió: $e');
    }
  }
}