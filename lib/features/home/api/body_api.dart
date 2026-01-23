import 'package:dio/dio.dart';
import '../../../api/dio_client.dart';
import '../models/body_today_model.dart';

class BodyApi {
  final Dio _dio = DioClient.dio;

  // GET /api/home
  Future<BodyToday?> fetchTodayBody() async {
    final res = await _dio.get('/api/home');

    final data = res.data;

    if (data == null) return null;

    if (data is! Map<String, dynamic>) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
        error: 'Unexpected response type: ${data.runtimeType}',
      );
    }

    return BodyToday.fromJson(data);
  }
}
