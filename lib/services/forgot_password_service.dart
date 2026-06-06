import 'package:birrawrapped/services/api_client.dart';

class ForgotPasswordService {
  final _client = ApiClient();

  Future<void> sendResetCode(String email) async {
    await _client.post('/api/auth/send-reset-code', {
      'email': email,
    });
    print("Codi de recuperació enviat!");
  }

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    await _client.post('/api/auth/reset-password', {
      'email': email,
      'code': code,
      'newPassword': newPassword,
    });
    print("Contrasenya canviada correctament!");
  }
}
