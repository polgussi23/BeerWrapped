// services/api_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Si fas servir dotenv

class ApiClient {
  // Singleton: Perquè sigui la mateixa instància a tot arreu
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  // Variables internes
  String? _authToken;
  final String _baseUrl = dotenv.env['API_URL'] ?? 'http://217.160.2.122:3100';

  // --- El Provider cridarà això ---
  void setAuthToken(String? token) {
    _authToken = token;
  }

  // --- Generador de Headers automàtic ---
  Map<String, String> get _headers {
    return {
      'Content-Type': 'application/json',
      if (_authToken != null) 'Authorization': 'Bearer $_authToken',
    };
  }

  // --- Mètodes Genèrics (GET, POST, PUT, DELETE) ---

  // GET
  Future<dynamic> get(String endpoint) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    final response = await http.get(uri, headers: _headers);
    return _processResponse(response);
  }

  // POST
  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    final response =
        await http.post(uri, headers: _headers, body: jsonEncode(body));
    return _processResponse(response);
  }

  // Helper per gestionar errors comuns
  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Sessió caducada (401)');
    } else {
      throw Exception('Error API: ${response.statusCode}');
    }
  }
}
