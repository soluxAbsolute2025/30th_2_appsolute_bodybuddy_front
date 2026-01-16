import 'package:dio/dio.dart';
import 'package:bodybuddy_frontend/api/dio_client.dart';
import 'package:bodybuddy_frontend/features/carebuddy/models/carebuddy_tag_suggest.dart';

class CarebuddyApi {
  final Dio _dio = DioClient.dio;

  Future<void> postMessage(String accessToken, String message) async {
    await _dio.post(
      'api/chat',
      options: Options(headers: {"Authorization": "Bearer ${accessToken}"}),
      data: {"message": message},
    );
  }

  Future<TagSuggest> getSuggest(String accessToken) async {
    final response = await _dio.get(
      'api/chat/suggest',
      options: Options(headers: {"Authorization": "Bearer ${accessToken}"}),
    );

    return TagSuggest.fromJson(response.data);
  }
}
