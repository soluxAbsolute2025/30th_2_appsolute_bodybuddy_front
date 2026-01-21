import 'package:dio/dio.dart';
import '../../../api/dio_client.dart';
import '../models/attendance_question_model.dart';
import '../models/attendance_answer_result_model.dart';
import '../models/weekly_attendance_model.dart';

class AttendanceApi {
  final Dio _dio = DioClient.dio;

  Future<AttendanceQuestion?> fetchQuestion() async {
    try {
      final res = await _dio.get('/api/attendance/question');
      return AttendanceQuestion.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final data = e.response?.data;
      final code = (data is Map<String, dynamic>) ? data['code'] : null;
      if (e.response?.statusCode == 400 && code == 'A002') return null;
      rethrow;
    }
  }

  Future<AttendanceAnswerResult> submitAnswer({
    required int questionId,
    required int optionId,
  }) async {
    final res = await _dio.post(
      '/api/attendance/answer',
      data: {'questionId': questionId, 'optionId': optionId},
    );
    return AttendanceAnswerResult.fromJson(res.data as Map<String, dynamic>);
  }

  Future<List<WeeklyAttendance>> fetchWeekly() async {
    final res = await _dio.get('/api/attendance/weekly');

    final data = res.data as Map<String, dynamic>;

    List<WeeklyAttendance> raw;
    final week = data['week'];
    if (week is List) {
      raw = week
          .whereType<Map<String, dynamic>>()
          .map(WeeklyAttendance.fromWeekJson)
          .toList();
    } else {
      final attendance = data['attendance'];
      raw = (attendance as List)
          .whereType<Map<String, dynamic>>()
          .map(WeeklyAttendance.fromAttendanceJson)
          .toList();
    }

    // --- ✅ 여기부터 "현재 주 날짜로 보정" (임시) ---
    final today = DateTime.now();
    final startOfWeek = DateTime(today.year, today.month, today.day)
        .subtract(Duration(days: today.weekday - DateTime.monday)); // 월요일

    // 서버에서 받은 status를 weekday(1~7) 기준으로 맵핑
    final statusByWeekday = <int, AttendanceStatus>{};
    for (final a in raw) {
      statusByWeekday[a.date.weekday] = a.status;
    }

    // 현재 주(월~일) 7칸을 만들고, weekday에 맞는 status를 끼워넣기
    return List.generate(7, (i) {
      final date = startOfWeek.add(Duration(days: i));
      final status = statusByWeekday[date.weekday] ?? AttendanceStatus.none;
      return WeeklyAttendance(date: date, status: status);
    });
  }
}
