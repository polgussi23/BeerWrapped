// services/groups_service.dart
import 'package:birrawrapped/services/api_client.dart';

class GroupsService {
  final _client = ApiClient();

  // POST /api/groups — crear grup
  Future<Map<String, dynamic>> createGroup(
      String name, String description) async {
    final data = await _client.post('/api/groups', {
      'name': name,
      'description': description,
    });
    return {
      'groupId': data['groupId'],
      'code': data['code'],
    };
  }

  // POST /api/groups/:id/join — unir-se a un grup
  Future<void> joinGroup(String userId, String code) async {
    await _client.post('/api/groups/$userId/join', {'code': code});
  }

  // GET /api/groups/:id — obtenir grups de l'usuari
  Future<List<Map<String, dynamic>>> getAllUserGroups(String userId) async {
    final data = await _client.get('/api/groups/$userId');
    final List<dynamic> list = data['groups'] ?? [];
    return list
        .map((item) => {
              'id': item['id'],
              'name': item['name'],
              'description': item['description'],
              'code': item['code'],
              'ownerId': item['owner_id'],
            })
        .toList();
  }

  // GET /api/groups/:groupId/members — membres del grup
  Future<List<Map<String, dynamic>>> getMembersOfGroup(String groupId) async {
    final data = await _client.get('/api/groups/$groupId/members');
    final List<dynamic> list = data['members'] ?? [];
    return list
        .map((item) => {
              'id': item['id'],
              'username': item['username'],
              'profileImage': item['profile_image'],
              'role': item['role'],
            })
        .toList();
  }

  // GET /api/groups/:groupId/history — historial del grup
  Future<List<Map<String, dynamic>>> getGroupBeersHistory(
      String groupId, String date) async {
    final data = await _client
        .get('/api/groups/$groupId/history', queryParams: {'date': date});
    final List<dynamic> list = data['history'] ?? [];
    return list
        .map((item) => {
              'username': item['username'],
              'profileImage': item['profile_image'], // <-- afegeix això
              'name': item['name'],
              'date': item['date'],
              'time': item['time'],
              'dayOfWeek': item['day_of_week'],
            })
        .toList();
  }

  Future<List<Map<String, dynamic>>> getMeetupAttendees(
      String groupId, String meetupId) async {
    final data =
        await _client.get('/api/groups/$groupId/meetups/$meetupId/attendees');
    final List<dynamic> list = data['attendees'] ?? [];
    return list
        .map((item) => {
              'id': item['id'],
              'username': item['username'],
              'profileImage': item['profile_image'],
            })
        .toList();
  }

  // POST /api/groups/:groupId/meetups — crear quedada
  Future<void> createMeetup(
      String groupId, String date, String time, String location) async {
    await _client.post('/api/groups/$groupId/meetups', {
      'date': date,
      'time': time,
      'location': location,
    });
  }

  // GET /api/groups/:groupId/meetups — obtenir quedades
  Future<List<Map<String, dynamic>>> getGroupMeetups(
      String groupId, String date) async {
    final data = await _client
        .get('/api/groups/$groupId/meetups', queryParams: {'date': date});
    final List<dynamic> list = data['meetups'] ?? [];
    return list
        .map((item) => {
              'id': item['id'],
              'date': item['date'],
              'time': item['time'],
              'location': item['location'],
              'creator': item['creator'],
              'attendeesCount': item['attendees_count'],
            })
        .toList();
  }

  // POST /api/groups/:groupId/meetups/:meetupId/attend — apuntar-se
  Future<void> attendToMeetup(
      String userId, String groupId, String meetupId) async {
    await _client
        .post('/api/groups/$groupId/meetups/$userId/$meetupId/attend', {});
  }

  Future<void> removeMember(String groupId, String userId) async {
    await _client.delete('/api/groups/$groupId/members/$userId');
  }

  Future<void> updateMemberRole(
      String groupId, String userId, String role) async {
    await _client
        .put('/api/groups/$groupId/members/$userId/role', {'role': role});
  }
}
