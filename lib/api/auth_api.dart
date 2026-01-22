import 'package:dio/dio.dart';
import 'dio_client.dart';

class AuthApi {
  final Dio _dio = DioClient.dio;

  // Post /api/users/logout
  Future<void> logoutUser() async {
    final response = await _dio.post('/api/users/logout');

    print(response.data);
  }

  // DELETE /api/users
  Future<void> deleteUser() async {
    final response = await _dio.delete('/api/users');

    print("회원 탈퇴 완료 : ");
    print(response);
  }
}
