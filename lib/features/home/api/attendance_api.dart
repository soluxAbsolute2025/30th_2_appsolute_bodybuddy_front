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

    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw Exception('weekly response is not a map');
    }

    final week = data['week'];
    if (week is! List) {
      throw Exception('weekly "week" is not a list');
    }

    return week
        .map((e) => WeeklyAttendance.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
