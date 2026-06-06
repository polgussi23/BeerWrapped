// services/sync_service.dart
import 'package:birrawrapped/services/beers_service.dart';
import 'package:birrawrapped/services/local_database.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final _localDb = LocalDatabase();
  final _beersService = BeersService();
  bool _isSyncing = false;

  /// Crida això una sola vegada al main.dart per escoltar canvis de xarxa.
  void startListening() {
    Connectivity().onConnectivityChanged.listen((results) {
      final hasConnection = results.any((r) => r != ConnectivityResult.none);
      if (hasConnection) syncPending();
    });
  }

  /// Intenta enviar totes les birres pendents al servidor.
  /// Es pot cridar manualment (p.ex. a l'inici de l'app) o automàticament.
  Future<bool> syncPending() async {
    if (_isSyncing) return false;
    _isSyncing = true;
    bool allSynced = false;

    try {
      final pending = await _localDb.getPendingBeers();
      if (pending.isEmpty) return true; // no hi havia res pendent = tot ok

      for (final beer in pending) {
        try {
          await _beersService.postBeerToUser(
            beer['user_id'],
            beer['beer_id'],
            beer['date'],
            beer['time'],
            beer['day_of_week'],
          );
          await _localDb.markAsSynced(beer['local_id']);
        } catch (e) {
          return false; // xarxa fallida
        }
      }
      allSynced = true;
    } finally {
      _isSyncing = false;
    }

    return allSynced;
  }
}
