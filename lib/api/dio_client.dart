import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../common/common.dart';

class DioClient {
  // 1. 변수는 하나만 남깁니다.
  static Dio? _dio;
  static const _storage = FlutterSecureStorage();

  static Dio get dio {
    if (_dio == null) {
      _dio = Dio(
        BaseOptions(
          baseUrl: 'http://52.79.228.227:8080',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      _dio!.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            // 2. 스토리지에서 토큰 가져오기 (비동기 방식 권장)
            final token = await _storage.read(key: 'accessToken') ?? Common.token;

            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }

            // 3. FormData(파일 업로드) 처리 로직 통합
            final isMultipart = options.data is FormData;
            if (!isMultipart) {
              options.headers['Content-Type'] = 'application/json';
            } else {
              // Multipart일 때는 Dio가 boundary를 스스로 정하도록 Content-Type을 비워둡니다.
              options.headers.remove('Content-Type');
            }

            print("🛫 [DIO] ${options.method} ${options.uri}");
            return handler.next(options);
          },
          onResponse: (response, handler) {
            print("✅ [DIO] 응답: ${response.statusCode}");
            return handler.next(response);
          },
          onError: (e, handler) {
            print("❌ [DIO] 에러: ${e.response?.statusCode} - ${e.message}");
            return handler.next(e);
          },
        ),
      );
    }
    return _dio!;
  }
}