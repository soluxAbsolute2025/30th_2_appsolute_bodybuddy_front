import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../common/common.dart';

class DioClient {
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
            // 1. 토큰 가져오기
            final token = await _storage.read(key: 'accessToken') ?? Common.token;

            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }

            // 2. FormData 및 Content-Type 처리 (중복 로직 통합)
            final isMultipart = options.data is FormData;

            if (isMultipart) {
              // Multipart일 때는 Dio가 boundary를 스스로 정하도록 설정을 맡깁니다.
              options.headers.remove('Content-Type');
              options.contentType = null;
            } else {
              // 일반 JSON 요청 설정
              options.headers['Content-Type'] = 'application/json';
              options.contentType = Headers.jsonContentType;
            }

            // 로그 출력
            print("[DIO] ${options.method} ${options.uri}");
            print("[DIO] headers: ${options.headers}");
            print("[DIO] contentType: ${options.contentType}");
            print("[DIO] dataType: ${options.data.runtimeType}");

            return handler.next(options);
          },
          onResponse: (response, handler) {
            print("[DIO] ✅ 응답 ${response.statusCode}");
            print("[DIO] ✅ data: ${response.data}");
            return handler.next(response);
          },
          onError: (e, handler) {
            print("[DIO] ❌ 에러 status: ${e.response?.statusCode}");
            print("[DIO] ❌ 에러 data: ${e.response?.data}");
            print("[DIO] ❌ message: ${e.message}");
            return handler.next(e);
          },
        ),
      );
    } // if (_dio == null) 닫는 괄호 추가

    return _dio!;
  }
}