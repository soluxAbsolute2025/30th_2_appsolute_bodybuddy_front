// lib/api/alarm_setting_api.dart
import '../../../api/dio_client.dart'; // 경로 확인 필수

class AlarmSettingApi { // 클래스명도 변경
  // 1. 알람 목록 가져오기 (리턴 타입 Map)
  static Future<Map<String, dynamic>> getAlarms() async {
    try {
      final response = await DioClient.dio.get('/api/notification-rule');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      print('알람 로딩 실패: $e');
      return {};
    }
  }

  // 2. 알람 추가
  static Future<void> addAlarm(String category, String label, String time) async {
    await DioClient.dio.post('/api/notification-rule', data: {
      "category": category,
      "label": label,
      "alarmTime": time,
      "isEnabled": true,
      "repeatDays": ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
    });
  }

  // 3. 알람 수정 (인자 4개 확실히 반영)
  static Future<void> updateAlarm(int id, String label, String time, bool isEnabled) async {
    await DioClient.dio.put('/api/notification-rule/$id', data: {
      "label": label,
      "alarmTime": time,
      "isEnabled": isEnabled,
    });
  }

  // 4. 알람 삭제
  static Future<void> deleteAlarm(int id) async {
    await DioClient.dio.delete('/api/notification-rule/$id');
  }
}