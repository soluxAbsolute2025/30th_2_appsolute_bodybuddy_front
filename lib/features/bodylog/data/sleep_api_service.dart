// lib/features/bodylog/data/sleep_api_service.dart

import 'package:dio/dio.dart';
import '../../../../common/common.dart'; // ★ Common 클래스 import (토큰 사용을 위해)
import 'sleep_model.dart';

class SleepApiService {
  // 에뮬레이터: 10.0.2.2, 실제기기: 본인 컴퓨터 IP
  final String _baseUrl = 'http://52.79.228.227:8080';

  late final Dio _dio;

  SleepApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      headers: {
        // 👇 [핵심 수정] 이 줄이 없으면 403 에러가 뜹니다!
        'Authorization': 'Bearer ${Common.token}',
        'Content-Type': 'application/json',
      },
    ));
  }

  // [GET] 수면 기록 조회
  Future<SleepRecord?> getSleepLog(String date) async {
    try {
      final response = await _dio.get(
        '/api/sleep-log',
        queryParameters: {'date': date},
      );

      // 데이터가 없거나 null일 경우 처리
      if (response.data['data'] == null) return null;

      return SleepRecord.fromJson(response.data['data']);
    } on DioException catch (e) {
      // 404 등 데이터가 없는 경우는 null 반환
      if (e.response?.statusCode == 404) {
        return null;
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
      print("보내는 토큰: ${Common.token}"); // 디버깅용: 토큰이 잘 찍히는지 확인
      print("보내는 데이터: $data");

      await _dio.post('/api/sleep-log', data: data);

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
      await _dio.patch('/api/sleep-log/$id', data: data);
    } catch (e) {
      print('수정 실패: $e');
      rethrow;
    }
  }

  // [DELETE] 수면 기록 삭제
  Future<void> deleteSleepLog(int id) async {
    try {
      await _dio.delete('/api/sleep-log/$id');
    } catch (e) {
      print('삭제 실패: $e');
      rethrow;
    }
  }
}