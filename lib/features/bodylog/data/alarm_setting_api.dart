import 'package:dio/dio.dart';
import '../../../api/dio_client.dart';

class AlarmSettingApi {

  // [헬퍼 함수] 서버에서 오는 시간 형식이 객체({hour:7...})든 배열([7,0])이든 문자열("07:00")이든 "HH:mm:ss"로 변환
  static String _parseTime(dynamic timeData) {
    if (timeData == null) return "00:00:00";

    // 1. 이미 문자열인 경우 ("07:00" or "07:00:00")
    if (timeData is String) return timeData;

    // 2. 객체인 경우 (Swagger GET 예시: {"hour": 7, "minute": 30 ...})
    if (timeData is Map) {
      int h = timeData['hour'] ?? 0;
      int m = timeData['minute'] ?? 0;
      return "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:00";
    }

    // 3. 배열인 경우 (Java LocalTime 기본 직렬화: [7, 30])
    if (timeData is List && timeData.isNotEmpty) {
      int h = timeData[0];
      int m = timeData.length > 1 ? timeData[1] : 0;
      return "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:00";
    }

    return "00:00:00";
  }

  // 1. 알람 목록 조회
  static Future<Map<String, List<dynamic>>> getAlarms() async {
    try {
      final response = await DioClient.dio.get('/api/notification-rule');

      List<dynamic> listData = [];
      // 응답이 바로 List인지, data 필드 안에 있는지 확인
      if (response.data is List) {
        listData = response.data;
      } else if (response.data is Map && response.data['data'] is List) {
        listData = response.data['data'];
      }

      // 카테고리별 분류
      final Map<String, List<dynamic>> grouped = {
        'MEAL': [],
        'MEDICINE': [],
        'EXERCISE': [],
        'WATER': [],
      };

      for (var item in listData) {
        // category가 null일 수 있으므로 처리
        String category = (item['category'] ?? '').toString().toUpperCase();

        // 시간 포맷 통일하여 item에 재저장 (UI에서 쓰기 편하게)
        item['parsedTime'] = _parseTime(item['alarmTime']);

        if (grouped.containsKey(category)) {
          grouped[category]!.add(item);
        }
      }

      return grouped;
    } catch (e) {
      print('알람 로딩 실패: $e');
      return {'MEAL': [], 'MEDICINE': [], 'EXERCISE': [], 'WATER': []};
    }
  }

  // 2. 알람 추가
  // 2. 알람 추가
  static Future<void> addAlarm(String category, String label, String time) async {
    try {
      print("🚀 알람 추가 요청 데이터: category=$category, label=$label, time=$time");

      await DioClient.dio.post('/api/notification-rule', data: {
        "category": category,
        "label": label,
        "alarmTime": time,
        "isEnabled": true,
        "repeatDays": ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
      });
      print("✅ 알람 추가 성공");
    } on DioException catch (e) {
      // ★★★ 여기가 핵심입니다 ★★★
      print("❌ 알람 추가 실패 (HTTP ${e.response?.statusCode})");
      print("❌ 서버 에러 메시지: ${e.response?.data}");
      // 위 로그가 나오면 캡쳐해서 보여주세요. "JSON parse error" 같은 힌트가 들어있습니다.
      rethrow;
    }
  }

  // 3. 알람 수정 (PUT) - Swagger 명세 반영
  static Future<void> updateAlarm(int alarmId, String category, String label, String time, bool isEnabled) async {
    // API 명세: PUT /api/notification-rule/{alarmId}
    await DioClient.dio.put('/api/notification-rule/$alarmId', data: {
      "category": category, // 수정 시에도 카테고리 포함 (명세서 Body 예시에 있음)
      "label": label,
      "alarmTime": time, // "07:00" 형태 권장
      "isEnabled": isEnabled,
      "repeatDays": ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
    });
  }

  // 4. 알람 삭제
  static Future<void> deleteAlarm(int alarmId) async {
    await DioClient.dio.delete('/api/notification-rule/$alarmId');
  }
}