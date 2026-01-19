import 'package:dio/dio.dart';
import '../../../api/dio_client.dart';
import '../models/attendance_question_model.dart';
import '../models/attendance_answer_result_model.dart';

class AttendanceApi {
  final Dio _dio = DioClient.dio;

  Future<AttendanceQuestion> fetchQuestion() async {
    final res = await _dio.get('/api/attendance/question');
    return AttendanceQuestion.fromJson(res.data as Map<String, dynamic>);
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
}
