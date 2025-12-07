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

  Future<void> updateStartDate(String userId, DateTime newDate) async {
    final response = await _client.post('/api/users/$userId/start-day', {
      'startDay': newDate.toIso8601String(),
    });

    print("Start day guardat: $response");
    /*final token = await _getAccessToken();
    final Uri apiUrl = Uri.parse('$apiUrlBase/api/users/$userId/start-date');

    final response = await http.put(
      apiUrl,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'startDate': newDate.toIso8601String(),
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al modificar startDate: ${response.statusCode}');
    }
    */
  }
}
