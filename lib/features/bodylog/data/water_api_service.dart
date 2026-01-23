import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import '../../../api/dio_client.dart';
import 'water_model.dart';

class WaterApiService {
  final Dio _dio = DioClient.dio;

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

  // ✅ [POST] 물 기록 추가 (Swagger 명세에 맞춰 수정)
  Future<void> addWaterLog(int amount) async {
    try {
      final String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      final Map<String, dynamic> requestBody = {
        "recordId": 0,
        "recordDate": formattedDate,
        "unit": "ml",
        "amount": amount,    // 여기에 500이 들어가고
        "mlAmount": amount,  // 여기에도 500이 정확히 들어가야 합니다!
        "actionType": "DRINK"
      };

      print('🛫 전송 데이터: $requestBody'); // 터미널에서 amount가 500인지 꼭 확인!
      await _dio.post('/api/water-log', data: requestBody);
    } catch (e) {
      print('물 추가 에러: $e');
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
      // 실제 API가 있다면 주석을 풀고 사용하세요.
      // final response = await _dio.get('/api/water-log/weekly');

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