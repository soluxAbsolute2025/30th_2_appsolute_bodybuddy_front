import 'package:dio/dio.dart';
import '../common/common.dart';

class DioClient {
  static Dio? _dio;

  static Dio get dio {
    _dio ??=
        Dio(
            BaseOptions(
              baseUrl: 'http://52.79.228.227:8080',
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              headers: {"Content-Type": "application/json"},
            ),
          )
          ..interceptors.add(
            InterceptorsWrapper(
              onRequest: (options, handler) {
                final token = Common.token;
                print("[DIO] 현재 토큰: $token");

                if (token != null && token.isNotEmpty) {
                  options.headers['Authorization'] = 'Bearer $token';
                }
                return handler.next(options);
              },
              onResponse: (response, handler) {
                print("[DIO] 응답 ${response.statusCode}");
                return handler.next(response);
              },
              onError: (e, handler) {
              },
            ),
          );

    return _dio!;
  }
}
