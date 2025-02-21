import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/login_response.dart';

class LoginService{
  Future<LoginResponse> loginUser(String username, String password) async{
    final Uri apiUrl = Uri.parse('https://polgussi.cat:3001/login');
    
    try{
      final response = await http.post(
        apiUrl,
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