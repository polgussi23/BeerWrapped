// services/preferences_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PreferencesService {
  static const _beerHistoryKey = 'beer_history';

  static Future<void> saveBeerToHistory(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getBeerHistory();

    history.remove(id); // si ja existia, l'eliminem
    history.insert(0, id); // l'afegim al principi

    await prefs.setString(_beerHistoryKey, jsonEncode(history));
  }

  static Future<List<int>> getBeerHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_beerHistoryKey);
    if (raw == null) return [];
    return List<int>.from(jsonDecode(raw));
  }
}
