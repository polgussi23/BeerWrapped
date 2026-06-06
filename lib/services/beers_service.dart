// services/beers_service.dart
import 'dart:convert';
import 'package:birrawrapped/services/api_client.dart';
import 'package:birrawrapped/services/local_database.dart';
import 'package:birrawrapped/services/sync_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/beers_response.dart';

class BeersService {
  final _client = ApiClient();
  static const _cacheKey = 'cached_beers';

  // ── Llista de birres amb cache offline ──────────────────────────────────────

  Future<BeersResponse> getAllBeers() async {
    final cached = await _loadBeersCache();

    if (cached != null) {
      // Té cache: servim immediatament i refreskem en segon pla
      _client.get('/api/beers').then((data) => _saveBeersCache(data)).ignore();
      return cached;
    } else {
      // Primera vegada: no hi ha altra opció, esperem la API (amb els 8s de timeout)
      final data = await _client.get('/api/beers');
      await _saveBeersCache(data);
      return BeersResponse.fromJson(data);
    }
  }

  Future<void> saveBeerLocally(String userId, String beerId, String date,
      String time, String dayOfWeek) async {
    final localId = const Uuid().v4();
    await LocalDatabase().insertPendingBeer({
      'local_id': localId,
      'user_id': userId,
      'beer_id': beerId,
      'date': date,
      'time': time,
      'day_of_week': dayOfWeek,
    });
    print('💾 Birra guardada localment: $localId');
  }

  Future<void> _saveBeersCache(dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cacheKey, jsonEncode(data));
  }

  Future<BeersResponse?> _loadBeersCache() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_cacheKey);
    if (raw == null) return null;
    return BeersResponse.fromJson(jsonDecode(raw));
  }

  // ── Afegir birra (offline-first) ────────────────────────────────────────────

  Future<void> addBeerOfflineFirst(String userId, String beerId, String date,
      String time, String dayOfWeek) async {
    // 1. Sempre guardar local primer (instantani, sense xarxa)
    final localId = const Uuid().v4();
    await LocalDatabase().insertPendingBeer({
      'local_id': localId,
      'user_id': userId,
      'beer_id': beerId,
      'date': date,
      'time': time,
      'day_of_week': dayOfWeek,
    });
    print('💾 Birra guardada localment: $localId');

    // 2. Intentar sincronitzar ara (si no hi ha xarxa, fallarà silenciosament)
    await SyncService().syncPending();
  }

  // ── Mètodes existents (sense canvis) ────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getLast3DaysUserBeers(
      String userId, String date) async {
    final data = await _client
        .get('/api/beers/$userId/last-3-days', queryParams: {'date': date});

    final List<dynamic> list = data['userBeers'] ?? data;

    return list
        .map((item) => {
              'id': item['id'],
              'name': item['name'],
              'date': item['date'],
              'time': item['time'],
              'dayOfWeek': item['day_of_week'],
            })
        .toList();
  }

  Future<void> postBeerToUser(String userId, String beerId, String date,
      String time, String dayOfWeek) async {
    final response = await _client.post('/api/beers/$userId/add-beer', {
      'beerId': beerId,
      'date': date,
      'time': time,
      'dayOfWeek': dayOfWeek,
    });
    print("Beer pujada: ${response['message']}");
  }

  Future<void> deleteUserBeer(String userId, String beerId) async {
    final response = await _client.post('/api/beers/$userId/delete-beer', {
      'beerId': beerId,
    });
    print("Beer eliminada: ${response['message']}");
  }
}
