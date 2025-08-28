import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LogoutService {
  Future<String> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    final storage = FlutterSecureStorage();
    final refreshToken = await storage.read(
        key: 'refreshToken'); //RefreshToken a enviar al servidor

    // Eliminem el refreshToken del almacenamiento seguro
    await storage.delete(key: 'refreshToken');
    await prefs.clear(); // Eliminem totes les dades de SharedPreferences

    final String apiUrlBase =
        dotenv.env['API_URL'] ?? 'http://217.160.2.122:3100';

    final Uri apiUrlLogout = Uri.parse('$apiUrlBase/api/auth/logout');

    try {
      final response = await http.post(
        apiUrlLogout,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${refreshToken ?? ''}'
        },
      );

      if (response.statusCode == 200) {
        return 'Logout successful';
      } else {
        throw Exception('Error en el logout: ${response.body}');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
