import 'package:birrawrapped/services/api_client.dart';
import 'package:http/http.dart';
import 'dart:convert';
import '../models/beers_response.dart';

class BeersService {
  final _client = ApiClient();

  Future<BeersResponse> getAllBeers() async {
    final data = await _client.get('/api/beers');
    final r = BeersResponse.fromJson(data);
    return r;
  }

  Future<BeersResponse> getCustomUserBeers(String userId) async {
    final data = await _client.get('/api/beers/$userId/custom');
    final r = BeersResponse.fromJson(data);
    return r;
  }

  Future<void> postCustomUserBeer(String userId, String name) async {
    final response =
        await _client.post('/api/beers/$userId/custom', {'name': name});
    print("Beer pujada: ${response['message']}");
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
}
