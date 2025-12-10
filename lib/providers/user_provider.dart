import 'package:beerwrapped/models/login_response.dart';
import 'package:beerwrapped/models/register_response.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_client.dart';

class UserProvider extends ChangeNotifier {
  final _storage = FlutterSecureStorage();
  int? _userId;
  String? _username;
  DateTime? _startDay;

  String? _accessToken;
  String? _refreshToken;

  bool isLogged() {
    if (_accessToken == null) {
      return false;
    } else {
      return true;
    }
  }

  int? getUserId() {
    return _userId;
  }

  String? getRefreshToken() {
    return _refreshToken;
  }

  String? getUsername() {
    return _username;
  }

  DateTime? getStartDay() {
    return _startDay;
  }

  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();

    _userId = prefs.getInt('userId');
    _username = prefs.getString('username');

    try {
      final dateStr = prefs.getString('startDay');
      if (dateStr != null && dateStr.isNotEmpty) {
        _startDay = DateFormat('yyyy-MM-dd', 'ca').parse(dateStr);
      }
    } catch (e) {
      print("Error llegint la data: $e");
      _startDay = null; // En cas d'error, el deixem buit per no bloquejar l'app
    }

    //_accessToken = prefs.getString('accessToken');
    _accessToken = await _storage.read(key: 'accessToken');
    _refreshToken = await _storage.read(key: 'refreshToken');

    ApiClient().configure(
      accessToken: _accessToken,
      refreshToken: _refreshToken,
      onRefreshed: _handleTokensRefreshed, // Li passem la funció de dalt
      onExpired: _handleSessionExpired, // Li passem la funció de logout
    );

    notifyListeners();
  }

  Future<void> setSessionFromLoginResponse(LoginResponse r) async {
    final prefs = await SharedPreferences.getInstance();
    _userId = r.userId;
    _username = r.username;
    try {
      final dateStr = r.startDay;
      if (dateStr != null && dateStr.isNotEmpty) {
        _startDay = DateFormat('yyyy-MM-dd', 'ca').parse(dateStr);
      }
    } catch (e) {
      print("Error llegint la data: $e");
      _startDay = null; // En cas d'error, el deixem buit per no bloquejar l'app
    }
    _accessToken = r.accessToken;
    _refreshToken = r.refreshToken;

    prefs.setInt('userId', r.userId);
    prefs.setString('username', r.username);
    prefs.setString('startDay', r.startDay ?? '');

    await _storage.write(key: 'accessToken', value: r.accessToken);
    await _storage.write(key: 'refreshToken', value: r.refreshToken);

    ApiClient().configure(
      accessToken: r.accessToken,
      refreshToken: r.refreshToken,
      onRefreshed: _handleTokensRefreshed,
      onExpired: _handleSessionExpired,
    );
  }

  void setStartDay(DateTime startDay) async {
    _startDay = startDay;

    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        'startDay', DateFormat('yyyy-MM-dd', 'ca').format(startDay));
  }

  Future<void> setSessionFromRegisterResponse(RegisterResponse r) async {
    final prefs = await SharedPreferences.getInstance();
    _userId = r.userId;
    _username = r.username;

    _accessToken = r.accessToken;
    _refreshToken = r.refreshToken;

    prefs.setInt('userId', r.userId);
    prefs.setString('username', r.username);

    await _storage.write(key: 'accessToken', value: r.accessToken);
    await _storage.write(key: 'refreshToken', value: r.refreshToken);

    ApiClient().configure(
      accessToken: r.accessToken,
      refreshToken: r.refreshToken,
      onRefreshed: _handleTokensRefreshed,
      onExpired: _handleSessionExpired,
    );
  }

  Future<void> setSession(int id, String username, DateTime startDay,
      String access, String refresh) async {
    final prefs = await SharedPreferences.getInstance();

    _userId = id;
    _username = username;
    _startDay = startDay;
    _accessToken = access;
    _refreshToken = refresh;

    prefs.setInt('userId', id);
    prefs.setString('username', username);
    prefs.setString('startDay', startDay.toString());

    await _storage.write(key: 'accessToken', value: access);
    await _storage.write(key: 'refreshToken', value: refresh);
  }

  void _handleTokensRefreshed(String newAccess, String newRefresh) {
    _accessToken = newAccess;
    _refreshToken = newRefresh;

    // Guardem al disc silenciosament
    _storage.write(key: 'accessToken', value: newAccess);
    _storage.write(key: 'refreshToken', value: newRefresh);

    // No cal fer notifyListeners() perquè la UI no canvia, només la sessió interna
    print(
        "Tokens actualitzats i guardats al disc correctament via UserProvider");
  }

  // Aquesta funció s'executa si el refresh falla (el refresh token ha caducat)
  void _handleSessionExpired() {
    logout(); // Això esborra tot i la UI redirigirà al Login
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = null;
    _username = null;
    _startDay = null;
    _accessToken = null;
    _refreshToken = null;

    await prefs.clear();
    await _storage.deleteAll();
  }
}
