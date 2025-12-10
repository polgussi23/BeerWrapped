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
  String? _accessToken;
  String? _refreshToken;
  final String _baseUrl = dotenv.env['API_URL'] ?? 'http://217.160.2.122:3100';

  Function(String newAccess, String newRefresh)? onTokensRefreshed;
  Function()? onSessionExpired;

  //Configurem els tokens i els callbacks
  void configure(
      {String? accessToken,
      String? refreshToken,
      Function(String, String)? onRefreshed,
      Function()? onExpired}) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    if (onRefreshed != null) onTokensRefreshed = onRefreshed;
    if (onExpired != null) onSessionExpired = onExpired;
  }

  // --- Generador de Headers automàtic ---
  Map<String, String> get _headers {
    return {
      'Content-Type': 'application/json',
      if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
    };
  }

  // --- Mètodes Genèrics (GET, POST, PUT, DELETE) ---

  // GET
  Future<dynamic> get(String endpoint) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    final response = await http.get(uri, headers: _headers);
    //return _processResponse(response);
    if (response.statusCode == 401) {
      final refreshed = await _tryRefreshToken();
      if (refreshed) {
        print("Token renovat. Reitentant petició...");
        return get(endpoint);
      }
    }
    return _processResponse(response);
  }

  // POST
  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    final response =
        await http.post(uri, headers: _headers, body: jsonEncode(body));
    if (response.statusCode == 403) {
      final refreshed = await _tryRefreshToken();
      if (refreshed) {
        print("Token renovat. Reitentant petició...");
        return post(endpoint, body);
      }
    }

    return _processResponse(response);
  }

  // PUT
  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    final response =
        await http.put(uri, headers: _headers, body: jsonEncode(body));
    if (response.statusCode == 403) {
      final refreshed = await _tryRefreshToken();
      if (refreshed) {
        print("Token renovat. Reitentant petició...");
        return post(endpoint, body);
      }
    }

    return _processResponse(response);
  }

  Future<bool> _tryRefreshToken() async {
    if (_refreshToken == null) return false;

    try {
      final uri = Uri.parse('$_baseUrl/api/auth/refresh-token');
      // Normalment el refresh token s'envia al body o com a header, ajusta segons la teva API
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_refreshToken'
        },
        //body: jsonEncode({'refreshToken': _refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccess =
            data['accessToken']; // Ajusta les claus segons el teu JSON
        final newRefresh =
            data['refreshToken']; // A vegades el refresh també canvia

        // 1. Actualitzem memòria de l'ApiClient
        _accessToken = newAccess;
        _refreshToken = newRefresh ??
            _refreshToken; // Si no en torna un de nou, mantenim el vell

        // 2. Avisem al UserProvider perquè ho guardi al disc
        if (onTokensRefreshed != null && newAccess != null) {
          onTokensRefreshed!(newAccess, _refreshToken!);
        }
        return true;
      } else {
        // Si el refresh falla (ex: el refresh token també ha caducat), fem logout
        if (onSessionExpired != null) onSessionExpired!();
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // Helper per gestionar errors comuns
  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Petita millora: a vegades la API torna buit i jsonDecode peta
      if (response.body.isEmpty) return {};
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Sessió caducada (401) - No s\'ha pogut renovar');
    } else if (response.statusCode == 403) {
      throw Exception('No tens permisos (403)');
    } else {
      throw Exception('Error API: ${response.statusCode} ${response.body}');
    }
  }
}
