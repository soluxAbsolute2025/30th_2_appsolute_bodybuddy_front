import 'package:dio/dio.dart';
import 'package:bodybuddy_frontend/api/dio_client.dart';
import 'package:bodybuddy_frontend/features/buddyzone/models/feeds/feed_content_model.dart';
import 'package:bodybuddy_frontend/features/buddyzone/models/feeds/feed_type_model.dart';

class HattagApi {
  final Dio _dio = DioClient.dio;

  Future<List<String>> getHashtag(String accessToken) async {
    final response = await _dio.post(
      '/api/feeds/hashtag/popular',
      options: Options(headers: {"Authorization": "Bearer ${accessToken}"}),
    );

    return List<String>.from(response.data);
  }
}

class FeedsApi {
  final Dio _dio = DioClient.dio;

  Future<void> postFeeds(String accessToken) async {
    final response = await _dio.post(
      '/api/feeds',
      options: Options(headers: {"Authorization": "Bearer ${accessToken}"}),
      data: {
        'title': '오늘의 하체 운동 루틴',
        'content': '오늘은 스쿼트와 런지를 중점적으로 했습니다.',
        'visibility': 'PUBLIC',
        'hashtags': ["오운완", "하체운동", "스쿼트"],
      },
    );
    print("아니그래서 뭐가 문제야:" + response.statusCode.toString());
  }

  Future<void> postFeedLike(
    String accessToken,
    int feedId,
    bool isLiked,
  ) async {
    final response = await _dio.post(
      '/api/feeds/${feedId}/likes',
      options: Options(headers: {"Authorization": "Bearer ${accessToken}"}),
    );
    print(response);
  }
}

class FeedRequestAPI {
  final Dio _dio = DioClient.dio;

  Future<FeedPageResponse> getFeedRequest({
    required String accessToken,
    required FeedRequest request,
  }) async {
    Response response;

    switch (request.mode) {
      case FeedMode.normal:
        response = await _dio.get(
          '/api/feeds',
          options: Options(headers: {"Authorization": "Bearer ${accessToken}"}),
          queryParameters: {'page': 0, 'size': 10},
        );
        print(response.data);
        break;
      case FeedMode.search:
        response = await _dio.get(
          '/api/feeds/search',
          options: Options(headers: {"Authorization": "Bearer ${accessToken}"}),
          queryParameters: {'keyword': request.keyword, 'page': 0, 'size': 10},
        );
        print(response.data);
        break;
      case FeedMode.tag:
        response = await _dio.get(
          '/api/feeds/hashtag',
          options: Options(headers: {"Authorization": "Bearer ${accessToken}"}),
          queryParameters: {'tagName': request.tag, 'page': 0, 'size': 10},
        );
        print(response.data);
        break;
    }
    return FeedPageResponse.fromJson(response.data);
  }
}
