import 'package:dio/dio.dart';
import 'package:bodybuddy_frontend/api/dio_client.dart';
import 'package:bodybuddy_frontend/features/buddyzone/models/feeds/feed_content_model.dart';

class HattagApi {
  final Dio _dio = DioClient.dio;

  Future<List<String>> getHattag(String accessToken) async {
    final response = await _dio.post(
      '/api/feeds/hashtag/popular',
      options: Options(headers: {"Authorization": "Bearer ${accessToken}"}),
    );

    return List<String>.from(response.data);
  }

  Future<FeedPageResponse> getTagSearchFeed(
    String accessToken,
    String tagName,
    int page,
  ) async {
    final response = await _dio.get(
      '/api/feeds/hashtag',
      options: Options(headers: {"Authorization": "Bearer ${accessToken}"}),
      queryParameters: {'tagName': tagName, 'page': page, 'size': 10},
    );

    return FeedPageResponse.fromJson(response.data);
  }
}
