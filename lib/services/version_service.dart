import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class VersionService {
  final String _baseUrl = dotenv.env['API_URL'] ?? '';

  Future<Map<String, String>> checkVersion() async {
    final response = await http.get(Uri.parse('$_baseUrl/api/check-version'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'latestVersion': data['latestVersion'],
        'minVersion': data['minVersion'],
      };
    }
    throw Exception('Error al comprovar la versió');
  }
}
