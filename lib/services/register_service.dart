import 'package:beerwrapped/models/register_response.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class RegisterService {
  Future<RegisterResponse> registerUser(
      String username, String email, String password) async {
    final String apiUrlBase =
        dotenv.env['API_URL'] ?? 'http://217.160.2.122:3100';

    final Uri apiUrlRegister = Uri.parse('$apiUrlBase/api/auth/register');

    try {
      final response = await http.post(
        apiUrlRegister,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
          'email': email
        }),
      );

      if (response.statusCode == 201) {
        return RegisterResponse.fromJson(jsonDecode(response.body), username);
      } else {
        throw Exception('Error en el registre: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
