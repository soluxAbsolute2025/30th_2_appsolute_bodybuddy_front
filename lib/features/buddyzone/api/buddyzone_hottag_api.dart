import 'package:dio/dio.dart';
import 'package:bodybuddy_frontend/api/dio_client.dart';
import 'package:bodybuddy_frontend/features/buddyzone/models/feeds/feed_content_model.dart';
import 'package:bodybuddy_frontend/features/buddyzone/models/feeds/feed_type_model.dart';
import '../../../common/common.dart';

class HattagApi {
  final Dio _dio = DioClient.dio;

  Future<List<String>> getHashtag(String accessToken) async {
    final response = await _dio.post('/api/feeds/hashtag/popular');

    return List<String>.from(response.data);
  }
}

class FeedsApi {
  final Dio _dio = DioClient.dio;

  Future<void> postFeeds() async {
    final response = await _dio.post(
      '/api/feeds',
      data: {
        'title': '오늘의 하체 운동 루틴',
        'content': '오늘은 스쿼트와 런지를 중점적으로 했습니다.',
        'visibility': 'PUBLIC',
        'hashtags': ["오운완", "하체운동", "스쿼트"],
      },
    );
    print(response);
  }

  Future<List<String>> getHashtag() async {
    final response = await _dio.get('/api/feeds/hashtag/popular');
    print(response.data);
    return List<String>.from(response.data);
  }

  Future<void> detailFeeds({required int feedId}) async {
    final response = await _dio.delete('/api/feeds/${feedId}');
    print(response);
  }

  Future<void> postFeedLike(int feedId) async {
    final response = await _dio.post('/api/posts/${feedId}/likes');
    print(response);
  }
}

class FeedRequestAPI {
  final Dio _dio = DioClient.dio;

  Future<FeedPageResponse> getFeedRequest({
    required FeedRequest request,
  }) async {
    Response response;

    switch (request.mode) {
      case FeedMode.normal:
        response = await _dio.get(
          '/api/feeds',
          queryParameters: {'page': 0, 'size': 10},
        );
        print(response.data);
        break;
      case FeedMode.search:
        response = await _dio.get(
          '/api/feeds/search',
          queryParameters: {'keyword': request.keyword, 'page': 0, 'size': 10},
        );
        print("검색 API : " + response.data.toString());
        break;
      case FeedMode.tag:
        response = await _dio.get(
          '/api/feeds/hashtag',
          queryParameters: {'tagName': request.tag, 'page': 0, 'size': 10},
        );
        print("태그 API : " + response.data.toString());
        break;
    }
    return FeedPageResponse.fromJson(response.data);
  }
}
