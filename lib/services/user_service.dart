// services/user_service.dart
import 'dart:io';
import 'package:birrawrapped/services/api_client.dart';
import 'package:intl/intl.dart';
import 'package:birrawrapped/models/wrapped_data.dart';

class UserService {
  final _client = ApiClient();

  // GET /api/users/:id
  Future<Map<String, dynamic>> getUserData(String userId) async {
    final data = await _client.get('/api/users/$userId');
    final user = data['user'];
    return {
      'id': user['id'],
      'username': user['username'],
      'email': user['email'],
      'startDay': user['startDay'],
      'profileImage': user['profile_image'],
    };
  }

  // PUT /api/users/:id/username
  Future<void> updateUsername(String userId, String username) async {
    await _client.put('/api/users/$userId/username', {'username': username});
  }

  // PUT /api/users/:id/email
  Future<void> updateEmail(String userId, String email) async {
    await _client.put('/api/users/$userId/email', {'email': email});
  }

  // PUT /api/users/:id/password
  Future<void> updatePassword(
      String userId, String currentPassword, String newPassword) async {
    await _client.put('/api/users/$userId/password', {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    });
  }

  // PUT /api/users/:id/photo
  Future<String> updateProfileImage(String userId, File photo) async {
    final data = await _client.putFile(
      '/api/users/$userId/photo',
      photo,
      'photo',
    );
    return data['profile_image'];
  }

  Future<WrappedData?> getWrappedData(int userId) async {
    try {
      final data = await _client.get('/api/users/$userId/wrapped');
      final wrapped = data['wrapped'] as Map<String, dynamic>;
      return WrappedData.fromJson(wrapped);
    } catch (e) {
      print('Error carregant wrapped data: $e');
      return null;
    }
  }
}
