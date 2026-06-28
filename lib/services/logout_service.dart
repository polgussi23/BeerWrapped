import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:birrawrapped/services/notification_service.dart';

class LogoutService {
  Future<String> logoutUser(String? refreshToken, int? userId) async {
    final String apiUrlBase =
        dotenv.env['API_URL'] ?? 'http://217.160.2.122:3100';

    final Uri apiUrlLogout = Uri.parse('$apiUrlBase/api/auth/logout');

    try {
      // 1. Eliminem el device token ABANS de tancar sessió
      if (userId != null) {
        try {
          final fcmToken = await FirebaseMessaging.instance.getToken();
          if (fcmToken != null) {
            await NotificactionService()
                .deleteUserDeviceToken(userId, fcmToken);
          }
        } catch (e) {
          // No bloquegem el logout si falla això
          print('Error eliminant device token: $e');
        }
      }

      // 2. Fem el logout normal
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
