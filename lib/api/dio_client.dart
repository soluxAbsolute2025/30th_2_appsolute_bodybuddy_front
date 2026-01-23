import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioClient {
  // 1. 보안 저장소 (토큰 꺼내올 곳)
  static const storage = FlutterSecureStorage();

  // 2. Dio 기본 설정
  // 주의: 안드로이드 에뮬레이터라면 'http://10.0.2.2:8000'을 써야 할 수도 있습니다.
  // 실기기라면 컴퓨터의 내부 IP (예: 192.168.x.x)를 써야 합니다.
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://52.79.228.227:8080', // 서버 주소 확인!
      connectTimeout: const Duration(seconds: 5), // 1000초는 너무 기니 5초로 줄임
      receiveTimeout: const Duration(seconds: 3),
      headers: {"Content-Type": "application/json"},
    ),
  );

  // 3. 외부에서 DioClient.dio 로 부를 때 인터셉터(토큰 주입기) 장착
  static Dio get dio {
    // 인터셉터가 아직 안 달려있으면 추가
    if (_dio.interceptors.isEmpty) {
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            final accessToken = await storage.read(key: 'accessToken');

            // 토큰이 있으면 헤더에 'Bearer 토큰' 추가
            if (accessToken != null) {
              options.headers['Authorization'] = 'Bearer $accessToken';
              print('🔑 [Dio] 토큰 자동 주입됨: ${options.uri}');
            }
            // 👇 [CCTV 추가] 실제로 날아가는 헤더를 눈으로 확인합시다!
            print("🛫 [요청 헤더 확인] Authorization: ${options.headers['Authorization']}");
            print("🛫 [요청 헤더 확인] Content-Type: ${options.contentType}");

            return handler.next(options); // 다음 단계 진행
          },
          onError: (error, handler) {
            // 에러 발생 시 로그 출력
            print('❌ [Dio Error] ${error.message} (${error.response?.statusCode})');
            return handler.next(error);
          },
        ),
      );
    }
    return _dio;
  }
}