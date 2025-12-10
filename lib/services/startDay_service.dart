import 'package:beerwrapped/services/api_client.dart';

class StartDateService {
  final _client = ApiClient();

  Future<DateTime?> getStartDate(String userId) async {
    final data = await _client.get('/api/users/$userId/start-date');
    return DateTime.parse(data['startDate']);
  }

  Future<void> setStartDate(int userId, String startDate) async {
    final response = await _client.post('/api/users/$userId/start-day', {
      'startDay': startDate,
    });

    print("Start day guardat: ${response['message']}");
  }

  Future<void> updateStartDate(int userId, String newDate) async {
    final response = await _client.put('/api/users/$userId/start-day', {
      'startDay': newDate,
    });

    print("Start day guardat: $response");
  }
}
