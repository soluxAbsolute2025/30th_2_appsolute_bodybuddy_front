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
            // ✅ 여기서 Content-Type 강제 금지 (multipart 깨짐)
          ),
        )
          ..interceptors.add(
            InterceptorsWrapper(
              onRequest: (options, handler) {
                final token = Common.token;

                // auth
                if (token != null && token.isNotEmpty) {
                  options.headers['Authorization'] = 'Bearer $token';
                }

                // ✅ FormData가 아닐 때만 JSON으로
                final isMultipart = options.data is FormData;
                if (!isMultipart) {
                  options.headers['Content-Type'] = 'application/json';
                  options.contentType = Headers.jsonContentType;
                } else {
                  // ✅ multipart는 Dio가 boundary 포함해서 세팅하게 둔다
                  options.headers.remove('Content-Type');
                  options.contentType = 'multipart/form-data';
                }

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

    return _dio!;
  }
}
