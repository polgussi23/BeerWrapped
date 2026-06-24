import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class GroupQrDialog {
  /// Mostra el diàleg amb el QR i el codi d'accés del grup.
  /// Retorna el Future de showDialog, per poder fer await i encadenar accions.
  static Future<void> show(
    BuildContext context,
    String code, {
    String title = 'Convida al grup',
    String message = 'Escaneja el QR o comparteix el codi:',
    bool barrierDismissible = true,
    bool showQr = true,
  }) {
    final baseUrl = dotenv.env['API_URL'] ?? 'http://217.160.2.122:3100';
    final inviteUrl = '$baseUrl/join?code=$code';

    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (ctx) => _GroupQrDialogContent(
        code: code,
        inviteUrl: inviteUrl,
        title: title,
        message: message,
        showQr: showQr,
      ),
    );
  }
}

class _GroupQrDialogContent extends StatelessWidget {
  final String code;
  final String inviteUrl;
  final String title;
  final String message;
  final bool showQr;

  const _GroupQrDialogContent({
    required this.code,
    required this.inviteUrl,
    required this.title,
    required this.message,
    required this.showQr,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFEDE4D3),
      title: Text(
        title,
        style:
            const TextStyle(fontFamily: 'Kameron', fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: 260,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: const TextStyle(fontFamily: 'Kameron'),
            ),
            const SizedBox(height: 16),
            if (showQr) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: QrImageView(
                  data: inviteUrl,
                  version: QrVersions.auto,
                  size: 180,
                ),
              ),
              const SizedBox(height: 14),
            ],
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFB5884C),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    code,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Kameron',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 3,
                    ),
                  ),
                  const Text(
                    'codi d\'accés manual',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white70,
                      fontFamily: 'Kameron',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Share.share(
                    'Uneix-te al meu grup! 🍺\n$inviteUrl\n\nCodi: $code',
                  );
                },
                icon: const Icon(Icons.share, color: Colors.white),
                label: const Text(
                  'Compartir',
                  style: TextStyle(fontFamily: 'Kameron', color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Tancar'),
        ),
      ],
    );
  }
}
