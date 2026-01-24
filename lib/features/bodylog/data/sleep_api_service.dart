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
    ));
  }

  // [명세서 반영] 모든 요청에 필수 헤더 포함
  Options _getOptions() {
    return Options(headers: {
      'Authorization': 'Bearer ${Common.token}',
      'TimeZone': 'Asia/Seoul', // 이미지 1 가이드 준수
      'Content-Type': 'application/json',
    });
  }

  // 1. [GET] 특정 날짜 수면 기록 조회 (QueryParam: date)
  Future<SleepRecord?> getSleepLog(String date) async {
    try {
      final response = await _dio.get(
        '/api/sleep-log',
        queryParameters: {'date': date}, // 이미지 2, 4 가이드 반영
        options: _getOptions(),
      );

      if (response.data != null && response.data['data'] != null) {
        return SleepRecord.fromJson(response.data['data']);
      }
      return null;
    } catch (e) {
      print("❌ 조회 실패: $e");
      return null;
    }
  }

  // 2. [POST] 수면 기록 생성 (시간 포맷 초 단위 포함)
  Future<void> createSleepLog(String date, String bedTime, String wakeTime, String quality) async {
    try {
      final Map<String, dynamic> requestBody = {
        "sleepDate": date,
        "bedTime": bedTime.length == 5 ? "$bedTime:00" : bedTime, // "23:30" -> "23:30:00"
        "wakeTime": wakeTime.length == 5 ? "$wakeTime:00" : wakeTime,
        "sleepQuality": quality // 대문자 ENUM 값
      };

      await _dio.post(
        '/api/sleep-log',
        data: requestBody, // 이미지 3, 5 가이드 반영
        options: _getOptions(),
      );
    } catch (e) {
      rethrow;
    }
  }

  // 3. [PATCH] 수면 기록 수정
  Future<void> updateSleepLog(int id, String bedTime, String wakeTime, String quality) async {
    try {
      final Map<String, dynamic> updateData = {
        "sleepRecordId": id,
        "bedTime": bedTime.length == 5 ? "$bedTime:00" : bedTime,
        "wakeTime": wakeTime.length == 5 ? "$wakeTime:00" : wakeTime,
        "sleepQuality": quality
      };

      await _dio.patch(
        '/api/sleep-log/$id',
        data: updateData,
        options: _getOptions(),
      );
    } catch (e) {
      rethrow;
    }
  }

  // 4. [DELETE] 수면 기록 삭제
  Future<void> deleteSleepLog(int id) async {
    try {
      await _dio.delete(
        '/api/sleep-log/$id',
        options: _getOptions(),
      );
    } catch (e) {
      rethrow;
    }
  }

  // 5. [GET] 주간 수면 데이터 (엔드포인트 경로 수정)
  Future<WeeklySleepStats?> getWeeklySleepLog(String startDate, String endDate) async {
    try {
      final response = await _dio.get(
        '/api/sleep-log/weekly', // 이미지 7 명세서 엔드포인트로 수정
        queryParameters: {'startDate': startDate, 'endDate': endDate},
        options: _getOptions(),
      );

      if (response.statusCode == 200 && response.data != null) {
        final rawData = response.data['data'] ?? response.data;
        return WeeklySleepStats.fromJson(rawData);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // 6. [GET] 수면 품질 분석
  Future<Map<String, dynamic>> getSleepQuality(String startDate, String endDate) async {
    try {
      final response = await _dio.get(
        '/api/sleep/quality',
        queryParameters: {'startDate': startDate, 'endDate': endDate},
        options: _getOptions(),
      );
      return response.data['data'] ?? response.data ?? {};
    } catch (e) {
      rethrow;
    }
  }
}