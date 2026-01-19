import 'package:dio/dio.dart';
import 'dio_client.dart';

class AuthApi {
  final Dio _dio = DioClient.dio;

  // Post /api/users/login
  Future<void> login(String loginId, String password) async {
    await _dio.post('/api/users/login');
  }

  // Post /api/users/logout
  Future<void> logout(String accessToken) async {
    await _dio.post(
      '/api/users/logout',
      options: Options(headers: {"Authorization": "Bearer ${accessToken}"}),
    );
  }

  // DELETE /api/users
  Future<void> deleteUser(String accessToken) async {
    await _dio.delete(
      '/api/users',
      options: Options(headers: {"Authorization": "Bearer ${accessToken}"}),
    );
  }
}
