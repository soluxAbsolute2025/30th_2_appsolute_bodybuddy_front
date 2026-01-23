import 'package:dio/dio.dart';
import 'dio_client.dart'; // 위에서 수정한 파일 import

class NotificationApi {
  // 1. 알람 전체 조회 (GET)
  static Future<List<dynamic>> getAlarms() async {
    // DioClient.dio를 쓰면 토큰이 자동으로 들어감!
    final response = await DioClient.dio.get('/api/notification-rule');

    // 서버 응답 구조에 따라 return 값 조정 필요
    // 예: return response.data; 또는 return response.data['result'];
    return response.data;
  }

  // 2. 알람 등록 (POST)
  static Future<void> addAlarm(String category, String content, String time) async {
    await DioClient.dio.post('/api/todos', data: {
      "category": category,
      "content": content,
      "alarmTime": time,
      "isEnabled": true,
    });
  }

  // 3. 알람 수정 (PATCH - 스위치 ON/OFF)
  static Future<void> updateAlarm(int alarmId, String time, bool isEnabled) async {
    await DioClient.dio.patch('/api/notification-rule/$alarmId', data: {
      "alarmId": alarmId,
      "alarmTime": time,
      "isEnabled": isEnabled,
    });
  }

  // 4. 알람 삭제 (DELETE)
  static Future<void> deleteAlarm(int alarmId) async {
    await DioClient.dio.delete(
      '/api/notification-rule/$alarmId',
      data: {"alarmId": alarmId},
    );
  }
}