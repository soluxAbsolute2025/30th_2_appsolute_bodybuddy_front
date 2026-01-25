import 'package:dio/dio.dart';
import '../../../../common/common.dart';
import 'sleep_model.dart';

class SleepApiService {
  final String _baseUrl = 'http://52.79.228.227:8080';
  late final Dio _dio;

  SleepApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      // [핵심] 403이나 400 에러가 나도 앱이 터지지 않게 막아줍니다.
      validateStatus: (status) => true,
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // 토큰 재확인 로직
        if (Common.token == null || Common.token!.isEmpty) {
          Common.token = await Common.storage.read(key: 'accessToken');
        }

        // 헤더 강제 주입
        options.headers['Authorization'] = 'Bearer ${Common.token}';
        options.headers['TimeZone'] = 'Asia/Seoul';
        options.headers['Content-Type'] = 'application/json';

        print("🚀 [요청] ${options.method} ${options.uri}");
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // [핵심] 서버가 보낸 응답을 무조건 찍어봅니다.
        if (response.statusCode! >= 400) {
          print("⚠️ [서버 에러 ${response.statusCode}] 메시지: ${response.data}");
        } else {
          print("✅ [성공 ${response.statusCode}] 데이터: ${response.data}");
        }
        return handler.next(response);
      },
      onError: (e, handler) {
        print("❌ [통신 실패] ${e.message}");
        return handler.next(e);
      },
    ));
  }

  // 1. 특정 날짜 조회
  Future<SleepRecord?> getSleepLog(String date) async {
    try {
      final response = await _dio.get(
        '/api/sleep-log',
        queryParameters: {'date': date},
      );

      // 403 에러가 나도 null을 반환하여 앱이 멈추지 않게 함
      if (response.statusCode != 200) return null;

      final data = response.data['data'] ?? response.data;
      if (data != null && data is Map<String, dynamic>) {
        return SleepRecord.fromJson(data);
      }
      return null;
    } catch (e) {
      print("코드 에러(조회): $e");
      return null;
    }
  }

  // 2. 기록 생성
  Future<void> createSleepLog(String date, String bedTime, String wakeTime, String quality) async {
    final Map<String, dynamic> requestBody = {
      "sleepDate": date,
      "bedTime": _ensureSeconds(bedTime),
      "wakeTime": _ensureSeconds(wakeTime),
      "sleepQuality": quality
    };
    await _dio.post('/api/sleep-log', data: requestBody);
  }

  // 3. 기록 수정 (Body에 ID 포함)
  Future<void> updateSleepLog(int id, String bedTime, String wakeTime, String quality) async {
    final Map<String, dynamic> updateData = {
      "sleepRecordId": id,
      "bedTime": _ensureSeconds(bedTime),
      "wakeTime": _ensureSeconds(wakeTime),
      "sleepQuality": quality
    };
    await _dio.patch('/api/sleep-log', data: updateData);
  }

  // 4. 기록 삭제 (Body에 ID 포함)
  Future<void> deleteSleepLog(int id) async {
    // validateStatus 덕분에 400 에러가 나도 여기서 로그가 찍힘
    await _dio.delete(
      '/api/sleep-log',
      data: {"sleepRecordId": id},
    );
  }

  // 5. 주간 데이터
  Future<WeeklySleepStats?> getWeeklySleepLog(String startDate, String endDate) async {
    try {
      final response = await _dio.get(
        '/api/sleep-log/weekly',
        queryParameters: {'startDate': startDate, 'endDate': endDate},
      );

      if (response.statusCode != 200) return null;

      final data = response.data['data'] ?? response.data;
      if (data != null) {
        return WeeklySleepStats.fromJson(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // 6. AI 분석용
  Future<Map<String, dynamic>> getSleepQuality(String startDate, String endDate) async {
    try {
      final response = await _dio.get(
        '/api/sleep-log/weekly',
        queryParameters: {'startDate': startDate, 'endDate': endDate},
      );
      return response.data['data'] ?? response.data ?? {};
    } catch (e) {
      return {};
    }
  }

  String _ensureSeconds(String time) {
    if (time.contains(':')) {
      List<String> parts = time.split(':');
      if (parts.length == 2) return "$time:00";
    }
    return time;
  }
}