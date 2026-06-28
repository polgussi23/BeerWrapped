import 'package:birrawrapped/services/api_client.dart';

class NotificactionService {
  final _client = ApiClient();

  Future<void> addUserDeviceToken(int userId, String token) async {
    await _client
        .post('/api/notification/$userId/device-token', {'deviceToken': token});
  }

  Future<void> deleteUserDeviceToken(int userId, String token) async {
    await _client.delete(
        '/api/notification/$userId/device-token', {'deviceToken': token});
  }
}
