// lib/features/bodylog/data/water_api_service.dart

import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import '../../../api/dio_client.dart'; // DioClient 가져오기
import 'water_model.dart';

class WaterApiService {
  // ✅ [핵심] DioClient.dio를 사용하면 끝입니다.
  // 생성자에서 _dio를 다시 만들거나 덮어쓰지 마세요!
  final Dio _dio = DioClient.dio;

  // [GET] 오늘 기록 조회
  Future<List<WaterLog>> getTodayLogs() async {
    try {
      final response = await _dio.get('/api/water-log/today');

      // 데이터가 없거나 null일 경우 빈 리스트 반환
      final List data = response.data ?? [];
      return data.map((json) => WaterLog.fromJson(json)).toList();
    } catch (e) {
      print('오늘 물 기록 조회 실패: $e');
      // 에러가 나도 앱이 죽지 않게 빈 리스트 반환
      return [];
    }
  }

  // [POST] 물 기록 추가
  Future<void> addWaterLog(int amount) async {
    try {
      // DioClient가 헤더(토큰)를 알아서 넣어주므로 body만 신경 쓰면 됩니다.
      await _dio.post('/api/water-log', data: {'amount': amount});
    } catch (e) {
      print('물 추가 실패: $e');
      rethrow;
    }
  }

  // [DELETE] 기록 삭제
  Future<void> deleteWaterLog(int id) async {
    try {
      await _dio.delete('/api/water-log/$id');
    } catch (e) {
      print('물 삭제 실패: $e');
      rethrow;
    }
  }

  // [GET] 주간 통계 조회
  Future<List<WaterDailyStat>> getWeeklyStats() async {
    try {
      // 임시 더미 데이터 (서버 API 구현 전까지 UI 유지용)
      List<WaterDailyStat> dummyStats = [];
      DateTime now = DateTime.now();
      for (int i = 6; i >= 0; i--) {
        DateTime day = now.subtract(Duration(days: i));
        dummyStats.add(WaterDailyStat(
          day: DateFormat('dd').format(day),
          totalAmount: 0,
        ));
      }
      return dummyStats;
    } catch (e) {
      print('주간 통계 조회 실패: $e');
      return [];
    }
  }
}