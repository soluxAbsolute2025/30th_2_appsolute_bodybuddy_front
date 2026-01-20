import 'package:dio/dio.dart';
import '../../../api/dio_client.dart';
import '../models/body_today_model.dart';

class BodyApi {
  final Dio _dio = DioClient.dio;

  // GET /api/body/today
  Future<BodyToday> fetchTodayBody() async {
    final res = await _dio.get('/api/home');

    return BodyToday.fromJson(
      res.data as Map<String, dynamic>,
    );
  }
}
