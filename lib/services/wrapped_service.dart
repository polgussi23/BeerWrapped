import 'package:birrawrapped/services/api_client.dart';
import 'package:flutter/material.dart';

class WrappedService {
  final _client = ApiClient();

  Future<({bool show, String? type})> getWrappedStatus(int userId) async {
    final data = await _client.get('/api/users/$userId/wrapped-status');
    final show = data['show'] as bool? ?? false;
    final type = data['type'] as String?;
    return (show: show, type: type);
  }

  Future<void> markWrappedAsSeen(int userId) async {
    await _client.put('/api/users/$userId/wrapped-seen', {});
  }

  /// Retorna true si cal mostrar el banner a la pantalla que crida aquest mètode.
  Future<bool> checkAndShowWrapped(BuildContext context, int? userId) async {
    if (userId == null) return false;

    final status = await getWrappedStatus(userId);
    if (!status.show) return false;

    if (status.type == 'banner') return true;

    if (status.type == 'popup') {
      if (!context.mounted) return false;

      final wantsToSee = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          backgroundColor: const Color(0xFFEDE4D3),
          title: const Text(
            'El teu BirraWrapped és aquí! 🍺',
            style: TextStyle(
              fontFamily: 'Kameron',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Ha passat un any! Vols veure el resum de totes les teves birres?',
            style: TextStyle(fontFamily: 'Kameron'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Més tard',
                  style: TextStyle(color: Colors.black54)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text(
                'Veure\'l ara! 🍻',
                style: TextStyle(
                  color: Color(0xFFB5884C),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );

      if (wantsToSee == true && context.mounted) {
        await markWrappedAsSeen(userId);
        Navigator.pushNamed(context, '/wrapped');
        return false;
      }

      return true; // Ha dit "més tard" → mostra el banner
    }

    return false;
  }
}
