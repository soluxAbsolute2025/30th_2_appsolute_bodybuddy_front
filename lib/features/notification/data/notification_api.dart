import 'package:dio/dio.dart';
import '../../../api/dio_client.dart'; // 기존 DioClient 경로

class NotificationApi {
  // 알림 내역 조회
  static Future<List<dynamic>> getNotificationHistory() async {
    try {
      // ★ 실제 API가 준비되면 아래 주석을 해제하세요.
      // final response = await DioClient.dio.get('/api/notifications');
      // return response.data;

      // [임시] API 개발 전까지 사용할 더미 데이터 (스크린샷 내용 반영)
      await Future.delayed(const Duration(milliseconds: 500)); // 로딩 흉내
      return [
        {
          "type": "MEAL",
          "title": "바디버디 식단 알람",
          "message": "아침 식사를 할 시간이에요!",
          "createdAt": DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String(),
        },
        {
          "type": "POKE",
          "title": "콕 찌르기 알림",
          "message": "러닝맘님이 나를 콕 찔렀어요! 피드 작성을 통해 나의 소식을 친구에게 알려보세요!",
          "createdAt": DateTime.now().subtract(const Duration(minutes: 30)).toIso8601String(),
        },
        {
          "type": "MEDICINE",
          "title": "바디버디 약/영양제 알람",
          "message": "아침 비타민을 먹을 시간이에요! 잊지 말고 약/영양제를 섭취하세요!",
          "createdAt": DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
        },
        {
          "type": "EXERCISE",
          "title": "바디버디 운동 알람",
          "message": "아침 운동을 할 시간이에요! 가벼운 산책이나 러닝을 통해 건강하고 상쾌한 아침을 시작해 보세요!",
          "createdAt": DateTime.now().subtract(const Duration(hours: 12)).toIso8601String(),
        },
      ];
    } catch (e) {
      print("알림 내역 로드 실패: $e");
      return [];
    }
  }
}