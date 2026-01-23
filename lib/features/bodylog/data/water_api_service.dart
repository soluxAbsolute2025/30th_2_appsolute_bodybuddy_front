// lib/features/bodylog/data/water_api_service.dart

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../../../../common/common.dart';
import 'water_model.dart';

class WaterApiService {
  // 에뮬레이터: 10.0.2.2, 실제기기: 본인 IP
  final String _baseUrl = 'http://10.0.2.2:8080';

  late final Dio _dio;

  WaterApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      headers: {
        'Authorization': 'Bearer ${Common.token}',
        'Content-Type': 'application/json',
      },
    ));
  }

  // [GET] 오늘 기록 조회
  Future<List<WaterLog>> getTodayLogs() async {
    try {
      final response = await _dio.get('/api/water-log/today');
      final List data = response.data ?? [];
      return data.map((json) => WaterLog.fromJson(json)).toList();
    } catch (e) {
      print('오늘 물 기록 조회 실패: $e');
      return [];
    }
  }

  // [POST] 물 기록 추가
  Future<void> addWaterLog(int amount) async {
    try {
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

  // [GET] 주간 통계 조회 (차트용)
  // ※ 서버에 주간 통계 API가 없다면, 이 부분은 추후 백엔드 개발이 필요합니다.
  // 현재는 "최근 7일 날짜를 생성"해서 리턴하는 구조로 잡아둡니다.
  Future<List<WaterDailyStat>> getWeeklyStats() async {
    try {
      // 1. (이상적) 서버 API 호출
      // final response = await _dio.get('/api/water-log/weekly');
      // return (response.data as List).map(...).toList();

      // 2. (임시) 현재는 서버 API가 없다고 가정하고,
      //    오늘 날짜 기준 최근 7일의 빈 데이터를 생성해서 UI가 깨지지 않게 함
      //    --> 서버 구현 후 위 1번 코드로 교체하세요.

      List<WaterDailyStat> dummyStats = [];
      DateTime now = DateTime.now();
      for (int i = 6; i >= 0; i--) {
        DateTime day = now.subtract(Duration(days: i));
        // 실제로는 여기서 날짜별 데이터를 서버에서 받아 매핑해야 함
        dummyStats.add(WaterDailyStat(
          day: DateFormat('dd').format(day), // "24", "25"
          totalAmount: 0, // 서버 연동 전까지 0으로 표시 (더미데이터 제거됨)
        ));
      }
      return dummyStats;

    } catch (e) {
      print('주간 통계 조회 실패: $e');
      return [];
    }
  }
}