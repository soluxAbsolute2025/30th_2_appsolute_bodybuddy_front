import 'package:dio/dio.dart';
import 'package:bodybuddy_frontend/api/dio_client.dart';
import 'package:bodybuddy_frontend/features/carebuddy/models/carebuddy_tag_suggest.dart';

class CarebuddyApi {
  final Dio _dio = DioClient.dio;

  Future<String> postMessage(String message) async {
    final response = await _dio.post('/api/chat', data: {"question": message});
    return response.data.toString();
  }

  Future<TagSuggest> getSuggest() async {
    final response = await _dio.get('/api/chat/suggest');
    print("getSuggest : " + response.data.toString());
    return TagSuggest.fromJson(response.data);
  }
}
