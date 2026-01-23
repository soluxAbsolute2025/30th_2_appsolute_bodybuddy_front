// lib/features/bodylog/data/sleep_api_service.dart

import 'package:dio/dio.dart';
import '../../../../common/common.dart'; // ★ Common 클래스 경로 확인
import 'sleep_model.dart';

class SleepApiService {
  // 에뮬레이터: 10.0.2.2, 실제기기: 본인 컴퓨터 IP (또는 서버 IP)
  final String _baseUrl = 'http://52.79.228.227:8080';

  late final Dio _dio;

  SleepApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      headers: {
        'Content-Type': 'application/json',
        // 생성 시점의 토큰 설정 (만약 앱 실행 중 토큰이 바뀌면 요청 때마다 넣는 게 좋음)
        'Authorization': 'Bearer ${Common.token}',
      },
    ));
  }

  // [GET] 하루 수면 기록 조회
  Future<SleepRecord?> getSleepLog(String date) async {
    try {
      // 요청 시마다 최신 토큰 사용을 위해 헤더 갱신
      final response = await _dio.get(
        '/api/sleep-log',
        queryParameters: {'date': date},
        options: Options(headers: {'Authorization': 'Bearer ${Common.token}'}),
      );

      if (response.data['data'] == null) return null;

      return SleepRecord.fromJson(response.data['data']);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null; // 데이터 없음
      }
      print('수면 조회 에러: ${e.response?.statusCode} / ${e.message}');
      return null;
    } catch (e) {
      print('수면 조회 일반 에러: $e');
      return null;
    }
  }

  // [POST] 수면 기록 추가
  Future<void> createSleepLog(Map<String, dynamic> data) async {
    try {
      print("보내는 토큰: ${Common.token}");
      print("보내는 데이터: $data");

      await _dio.post(
        '/api/sleep-log',
        data: data,
        options: Options(headers: {'Authorization': 'Bearer ${Common.token}'}),
      );

      print("✅ 수면 기록 성공!");
    } on DioException catch (e) {
      print("❌ 수면 기록 실패: ${e.response?.statusCode}");
      print("응답 내용: ${e.response?.data}");
      rethrow;
    }
  }

  // [PATCH] 수면 기록 수정
  Future<void> updateSleepLog(int id, Map<String, dynamic> data) async {
    try {
      await _dio.patch(
        '/api/sleep-log/$id',
        data: data,
        options: Options(headers: {'Authorization': 'Bearer ${Common.token}'}),
      );
    } catch (e) {
      print('수정 실패: $e');
      rethrow;
    }
  }

  // [DELETE] 수면 기록 삭제
  Future<void> deleteSleepLog(int id) async {
    try {
      await _dio.delete(
        '/api/sleep-log/$id',
        options: Options(headers: {'Authorization': 'Bearer ${Common.token}'}),
      );
    } catch (e) {
      print('삭제 실패: $e');
      rethrow;
    }
  }

  // [GET] 주간 수면 데이터 가져오기 (차트용)
  // ★ 기존에 밖에 있던 함수를 안으로 가져오고, _tokenService 대신 Common.token 사용으로 수정
  Future<WeeklySleepStats?> getWeeklySleepLog(String startDate, String endDate) async {
    try {
      // 쿼리 파라미터: ?startDate=2025-12-25&endDate=2025-12-31
      final response = await _dio.get(
        '/api/sleep/weekly',
        queryParameters: {
          'startDate': startDate,
          'endDate': endDate,
        },
        options: Options(headers: {'Authorization': 'Bearer ${Common.token}'}),
      );

      print("📊 [Weekly] 주간 데이터 응답: ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        // 응답 구조가 바로 객체라고 가정 (SleepModel.dart에 WeeklySleepStats가 있어야 함)
        // 만약 { "data": { ... } } 형태라면 response.data['data'] 로 수정 필요
        return WeeklySleepStats.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print("❌ 주간 데이터 로드 실패: $e");
      return null;
    }
  }

  // [GET] 수면 품질 분석 (기존 코드 유지)
  Future<Map<String, dynamic>> getSleepQuality(String startDate, String endDate) async {
    try {
      final response = await _dio.get(
        '/api/sleep/quality',
        queryParameters: {
          'startDate': startDate,
          'endDate': endDate,
        },
        options: Options(headers: {'Authorization': 'Bearer ${Common.token}'}),
      );

      if (response.data is Map<String, dynamic> && response.data['data'] != null) {
        return response.data['data'];
      }
      return response.data;
    } catch (e) {
      print('수면 품질 분석 실패: $e');
      rethrow;
    }
  }
}