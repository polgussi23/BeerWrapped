import 'package:birrawrapped/services/api_client.dart';

class EmailVerificationService {
  final _client = ApiClient();

  Future<void> sendVerificationCode(String email) async {
    try {
      await _client.post('/api/auth/send-verification', {
        'email': email,
      });
      print("Codi de verificació enviat!");
    } catch (e) {
      print("Error en enviar el codi de verificaicó...");
    }
  }

  Future<void> verifyCode(String email, String code) async {
    await _client.post('/api/auth/verify-code', {
      'email': email,
      'code': code,
    });
  }
}
