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
      final response = await _dio.get('/api/water-log/weekly');

      // 1. 서버 응답이 Map 형태인지 확인 ({ "2026-01-24": 500 })
      final Map<String, dynamic> apiData = (response.data is Map) ? response.data : {};

      List<WaterDailyStat> weeklyStats = [];
      DateTime now = DateTime.now();

      // 2. 최근 7일간 반복문 (그래프 틀 만들기)
      for (int i = 6; i >= 0; i--) {
        DateTime day = now.subtract(Duration(days: i));

        // 서버 Key와 맞출 포맷 (yyyy-MM-dd)
        String dateKey = DateFormat('yyyy-MM-dd').format(day);
        // UI에 보여줄 날짜 (dd)
        String displayDay = DateFormat('dd').format(day);

        // 3. 서버 데이터(apiData)에서 해당 날짜의 값이 있는지 확인
        int amount = 0;
        if (apiData.containsKey(dateKey)) {
          // value가 null이 아닐 경우 숫자로 변환
          amount = (apiData[dateKey] as num).toInt();
        }

        weeklyStats.add(WaterDailyStat(
          day: displayDay,
          totalAmount: amount,
        ));
      }

      return weeklyStats; // 가짜 데이터가 아닌 실제 계산된 데이터 반환!
    } catch (e) {
      print('❌ 주간 통계 API 처리 실패: $e');
      return [];
    }
  }
}