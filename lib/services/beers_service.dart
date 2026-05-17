import 'package:birrawrapped/services/api_client.dart';
import '../models/beers_response.dart';

class BeersService {
  final _client = ApiClient();

  Future<BeersResponse> getAllBeers() async {
    final data = await _client.get('/api/beers');
    final r = BeersResponse.fromJson(data);
    return r;
  }

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

  /*Future<BeersResponse> getCustomUserBeers(String userId) async {
    final data = await _client.get('/api/beers/$userId/custom');
    final r = BeersResponse.fromJson(data);
    return r;
  }

  Future<void> postCustomUserBeer(String userId, String name) async {
    final response =
        await _client.post('/api/beers/$userId/custom', {'name': name});
    print("Beer pujada: ${response['message']}");
  }*/

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
