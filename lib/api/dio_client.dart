import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioClient {
  static final Dio _dio = Dio();
  static const _storage = FlutterSecureStorage();

  static Dio get dio {
    _dio.options.baseUrl = 'http://52.79.228.227:8080'; // 서버 주소
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 3);

    // 기존 인터셉터 제거 (중복 방지)
    _dio.interceptors.clear();

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // 1. 저장소에서 토큰 꺼내기
          final token = await _storage.read(key: 'accessToken');

          // 2. 토큰이 있으면 헤더에 심기
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          // [디버깅용 로그] - 실제 날아가는 헤더 확인
          print("🛫 [전송] URL: ${options.path}");
          print("🛫 [전송] 헤더: ${options.headers['Authorization']}");

          return handler.next(options);
        },
        onError: (error, handler) {
          print("🚨 [오류] 상태 코드: ${error.response?.statusCode}");
          print("🚨 [오류] 메시지: ${error.response?.data}");
          return handler.next(error);
        },
      ),
    );

    return _dio;
  }
}